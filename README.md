# Cloudflare Terraform

Manages selected Cloudflare zone security settings, DMARC records, and a shared
Worker that serves `/.well-known/security.txt`.

## Prerequisites

- Terraform 1.9.8 (see `.terraform-version`)
- A Cloudflare API token with only the permissions required by the configured
  resources: Workers Scripts edit, Workers Routes edit, DNS edit, and Zone
  Settings edit for the selected account and zones
- A durable remote backend with encryption, access controls, locking, and
  versioning for any shared or production deployment

## Configure

```bash
cp terraform.tfvars.example terraform.tfvars
$EDITOR terraform.tfvars
export CLOUDFLARE_API_TOKEN='...'
```

`terraform.tfvars` and saved plans are ignored because both can contain
sensitive data. Keep the token out of Terraform variables so it is not written
to plans or state. Zone and account IDs are configuration, not credentials, but
are kept in the untracked environment file to avoid coupling this module to one
account.

Update `security_txt_expires` before it expires. Verify the contact mailbox.
Deploying an enforcing DMARC policy (`quarantine` or `reject`) before SPF and
DKIM alignment is confirmed can disrupt mail delivery.

## Check, plan, and apply

Offline-safe validation and mocked plan tests (the initial provider download
requires network, but no Cloudflare credentials or live API access):

```bash
./deploy.sh check
```

Create and review a plan without changing infrastructure:

```bash
./deploy.sh plan
terraform show terraform.tfplan
```

Apply is intentionally explicit and always creates a fresh saved plan:

```bash
./deploy.sh apply
```

Never apply from pull-request CI or expose plan output in public logs/comments.
Plans may contain secrets even when values are marked sensitive.

## State, imports, and drift

This repository does not prescribe a backend because backend selection is an
environment-level decision. Do not use local state for shared or production
infrastructure. Configure and test a remote backend before the first apply. If
state already exists, back it up and use `terraform init -migrate-state`; never
copy or commit state files.

Existing Cloudflare objects must be imported before the first apply to avoid
conflicts or replacement. Resource addresses are keyed by the names in
`var.zones`, so keep those keys stable. Follow the provider import formats and
confirm every proposed change.

Run a scheduled, credentialed `terraform plan -detailed-exitcode` in a protected
deployment environment to detect drift. Exit code `2` means drift or pending
changes and should require review. Keep applies behind environment approval,
least-privilege credentials, and branch protection.

## Scope and limitations

The `security_level` setting is not the same as Bot Fight Mode, AI bot blocking,
or AI Labyrinth. Those products have plan- and API-specific requirements and
are deliberately not claimed or managed here. Worker routes require registered
zones; a `workers.dev` hostname is not a zone and must not be added as one.
