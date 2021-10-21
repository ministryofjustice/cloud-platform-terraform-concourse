/*
 * Make sure that you use the latest version of the module by changing the
 * `ref=` value in the `source` attribute to the latest version listed on the
 * releases page of this repository.
 *
 */


module "example_team_concourse" {
  source = "../"
  # source = "github.com/ministryofjustice/cloud-platform-terraform-concourse?ref=v1.0"
  concourse_hostname                          = "concourse.apps.${data.terraform_remote_state.cluster.outputs.cluster_domain_name}"
  kops_or_eks                                 = var.kops_or_eks
  github_auth_client_id                       = var.github_auth_client_id
  github_auth_client_secret                   = var.github_auth_client_secret
  github_org                                  = var.github_org
  github_teams                                = var.github_teams
  tf_provider_auth0_client_id                 = var.tf_provider_auth0_client_id
  tf_provider_auth0_client_secret             = var.tf_provider_auth0_client_secret
  cloud_platform_infrastructure_git_crypt_key = var.cloud_platform_infrastructure_git_crypt_key
  slack_hook_id = var.slack_hook_id
  concourse-git-crypt    = var.concourse-git-crypt
  environments-git-crypt = var.environments-git-crypt
  github_token = var.github_token
  pingdom_user     = var.pingdom_user
  pingdom_password = var.pingdom_password
  pingdom_api_key  = var.pingdom_api_key
  dockerhub_username     = var.dockerhub_username
  dockerhub_access_token = var.dockerhub_access_token
  how_out_of_date_are_we_github_token = var.how_out_of_date_are_we_github_token
  sonarqube_token                             = var.sonarqube_token
  sonarqube_host                              = var.sonarqube_host
}


