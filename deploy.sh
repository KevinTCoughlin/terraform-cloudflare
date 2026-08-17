#!/usr/bin/env bash
set -Eeuo pipefail

readonly command_name="${1:-plan}"
readonly plan_file="${TF_PLAN_FILE:-terraform.tfplan}"

usage() {
  cat <<'EOF'
Usage: ./deploy.sh [check|plan|apply]

  check  Initialize without a backend, format-check, and validate.
  plan   Create a saved execution plan (default). Never applies changes.
  apply  Create a fresh plan, require explicit approval, and apply that plan.

Authentication is read only from CLOUDFLARE_API_TOKEN. Configuration belongs in
terraform.tfvars or TF_VAR_* environment variables.
EOF
}

if [[ "$command_name" != "check" && "$command_name" != "plan" && "$command_name" != "apply" ]]; then
  usage >&2
  exit 2
fi

if ! command -v terraform >/dev/null 2>&1; then
  echo "terraform is required; install the version in .terraform-version" >&2
  exit 1
fi

terraform fmt -check -recursive

if [[ "$command_name" == "check" ]]; then
  terraform init -backend=false -lockfile=readonly
  terraform validate
  terraform test
  exit 0
fi

if [[ -z "${CLOUDFLARE_API_TOKEN:-}" ]]; then
  echo "CLOUDFLARE_API_TOKEN must be set for planning and applying" >&2
  exit 1
fi

terraform init -lockfile=readonly
terraform validate
terraform plan -input=false -lock-timeout=5m -out="$plan_file"

if [[ "$command_name" == "plan" ]]; then
  echo "Saved plan to $plan_file; no infrastructure was changed."
  exit 0
fi

echo "Review the plan above. Type 'apply' to apply the saved plan."
read -r confirmation
if [[ "$confirmation" != "apply" ]]; then
  echo "Apply cancelled; no infrastructure was changed."
  exit 0
fi

terraform apply -input=false -lock-timeout=5m "$plan_file"
