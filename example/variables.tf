variable "kops_or_eks" {}
variable "github_auth_client_id" {}
variable "github_auth_client_secret" {}
variable "github_org" {}
variable "github_teams" {}
variable "tf_provider_auth0_client_id" {}
variable "tf_provider_auth0_client_secret" {}
variable "cloud_platform_infrastructure_git_crypt_key" {}
variable "slack_hook_id" {}
variable "concourse-git-crypt" {}
variable "environments-git-crypt" {}
variable "github_token" {}
variable "pingdom_user" {}
variable "pingdom_password" {}
variable "pingdom_api_key" {}
variable "pingdom_api_token" {}
variable "dockerhub_username" {}
variable "dockerhub_password" {}
variable "how_out_of_date_are_we_github_token" {}
variable "cloud_platform_infrastructure_pr_git_access_token" {}
variable "authorized_keys_github_token" {}
variable "vpc_id" {}
variable "internal_subnets" {}
variable "internal_subnets_ids" {}
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
  description = "Hostname of the 'how out of date are we' web application. Required when posting JSON data to it."
}
variable "hoodaw_api_key" {
  default     = ""
  description = "API key to authenticate data posts to https://how-out-of-date-are-we.apps.live-1.cloud-platform.service.justice.gov.uk"
}
variable "github_actions_secrets_token" {
  default     = ""
  description = "Github personal access token able to update any MoJ repository. Used to create github actions secrets"
}
