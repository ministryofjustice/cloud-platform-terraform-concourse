variable "github_auth_client_id" {}
variable "github_auth_client_secret" {}
variable "github_org" {}
variable "github_teams" {}
variable "cloud_platform_infrastructure_git_crypt_key" {}
variable "slack_hook_id" {}
variable "concourse-git-crypt" {}
variable "environments-git-crypt" {}
variable "github_token" {}
variable "pingdom_user" {}
variable "pingdom_password" {}
variable "pingdom_api_key" {}
variable "pingdom_api_token" {}
variable "slack_bot_token" {}
variable "slack_webhook_url" {}
variable "how_out_of_date_are_we_github_token" {}
variable "concourse_hostname" {}
variable "authorized_keys_github_token" {}

variable "dockerhub_username" {
  description = "Dockerhub password - used to pull images and avoid hitting dockerhub API limits"
}

variable "dockerhub_password" {
  description = "Dockerhub password - used to pull images and avoid hitting dockerhub API limits"
}

variable "cloud_platform_infrastructure_pr_git_access_token" {
  description = "Variable used to check PR status against cloud-platform-infrastructure repo"
}

variable "tf_provider_auth0_client_id" {
  description = "Client ID (prod) for auth0, it is used by divergence pipelines"
}

variable "tf_provider_auth0_client_secret" {
  description = "Client Secret (prod) for auth0, it is used by divergence pipelines"
}

variable "hoodaw_host" {
  default     = ""
  description = "URL of the 'how-out-of-date-are-we' web application"
}

variable "hoodaw_api_key" {
  default     = ""
  description = "API key to authenticate data posts to https://how-out-of-date-are-we.apps.live-1.cloud-platform.service.justice.gov.uk"
}

variable "teams_filter_api_key" {
  description = "API key to authenticate data posts to https://github-teams-filter.apps.live.cloud-platform.service.justice.gov.uk/filter-teams"
}

variable "github_actions_secrets_token" {
  default     = ""
  description = "Github personal access token able to update any MoJ repository. Used to create github actions secrets"
}


#### hoodaw #####
variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
}

variable "application" {
  description = "Name of Application you are deploying"
  default     = "How Out Of Date Are We"
}

variable "namespace" {
  default = "concourse-main"
}

variable "business_unit" {
  description = "Area of the MOJ responsible for the service."
  default     = "Platforms"
}

variable "team_name" {
  description = "The name of your development team"
  default     = "webops"
}

variable "environment" {
  description = "The type of environment you're deploying to."
  default     = "production"
}

variable "infrastructure_support" {
  description = "The team responsible for managing the infrastructure. Should be of the form team-email."
  default     = "platforms@digital.justice.gov.uk"
}

variable "is_production" {
  default = "true"
}

variable "slack_channel" {
  description = "Team slack channel to use if we need to contact your team"
  default     = "cloud-platform"
}
variable "github_owner" {
  description = "The GitHub organization or individual user account containing the app's code repo. Used by the Github Terraform provider. See: https://user-guide.cloud-platform.service.justice.gov.uk/documentation/getting-started/ecr-setup.html#accessing-the-credentials"
  type        = string
  default     = "ministryofjustice"
}

variable "hoodaw_irsa_enabled" {
  description = "Enable IRSA for hoodaw"
}

variable "limit_active_tasks" {
  description = "the maximum number of tasks a concourse worker can run"
  type        = number
  default     = 2
}

variable "environments_live_reports_s3_bucket" {
  description = "S3 bucket for storing apply-live reports"
  type        = string
}

variable "github_cloud_platform_concourse_bot_app_id" {
  description = "GitHub Concourse App credential: app_id"
  type        = string
  sensitive   = true
}

variable "github_cloud_platform_concourse_bot_installation_id" {
  description = "GitHub Concourse App credential: installation_id"
  type        = string
  sensitive   = true
}

variable "github_cloud_platform_concourse_bot_pem_file" {
  description = "GitHub Concourse App credential: private key pem_file"
  type        = string
  sensitive   = true
}