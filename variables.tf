variable "cloudflare_api_token" {
  description = "Cloudflare API token with zone edit permissions"
  type        = string
  sensitive   = true
  default     = "" # Can be set via CLOUDFLARE_API_TOKEN env var or TF_VAR_cloudflare_api_token
}

variable "cloudflare_account_id" {
  description = "Cloudflare account ID"
  type        = string
  default     = "" # Can be set via CLOUDFLARE_ACCOUNT_ID env var or TF_VAR_cloudflare_account_id
}
