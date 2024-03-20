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

variable "sonarqube_token" {
  default     = ""
  description = "Sonarqube token used to authenticate against sonaqube for scanning repos"
}

variable "sonarqube_host" {
  default     = ""
  description = "The host of the sonarqube"
}

variable "hoodaw_host" {
  default     = ""
  description = "URL of the 'how-out-of-date-are-we' web application"
}

variable "hoodaw_api_key" {
  default     = ""
  description = "API key to authenticate data posts to https://how-out-of-date-are-we.apps.live-1.cloud-platform.service.justice.gov.uk"
}

variable "github_actions_secrets_token" {
  default     = ""
  description = "Github personal access token able to update any MoJ repository. Used to create github actions secrets"
}


#### hoodaw #####
variable "eks_cluster_name" {
  description = "The name of the eks cluster to retrieve the OIDC information"
}

variable "application" {
  description = "Name of Application you are deploying"
  default     = "How Out Of Date Are We"
}

variable "hoodaw_namespace" {
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

variable "github_token" {
  type        = string
  description = "Required by the GitHub Terraform provider"
  default     = ""
}

