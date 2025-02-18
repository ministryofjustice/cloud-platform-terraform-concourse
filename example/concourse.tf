/*
 * Make sure that you use the latest version of the module by changing the
 * `ref=` value in the `source` attribute to the latest version listed on the
 * releases page of this repository.
 *
 */


module "example_team_concourse" {
  source = "../"
  # source = "github.com/ministryofjustice/cloud-platform-terraform-concourse?ref=v1.0"
  concourse_hostname                                = "cloud-platform.service.justice.gov.uk"
  github_auth_client_id                             = var.github_auth_client_id
  github_auth_client_secret                         = var.github_auth_client_secret
  github_org                                        = var.github_org
  github_teams                                      = var.github_teams
  tf_provider_auth0_client_id                       = var.tf_provider_auth0_client_id
  tf_provider_auth0_client_secret                   = var.tf_provider_auth0_client_secret
  cloud_platform_infrastructure_git_crypt_key       = var.cloud_platform_infrastructure_git_crypt_key
  cloud_platform_infrastructure_pr_git_access_token = var.cloud_platform_infrastructure_pr_git_access_token
  slack_hook_id                                     = var.slack_hook_id
  concourse-git-crypt                               = var.concourse-git-crypt
  environments-git-crypt                            = var.environments-git-crypt
  github_token                                      = var.github_token
  pingdom_user                                      = var.pingdom_user
  pingdom_password                                  = var.pingdom_password
  pingdom_api_key                                   = var.pingdom_api_key
  pingdom_api_token                                 = var.pingdom_api_token
  slack_bot_token                                   = var.slack_bot_token
  slack_webhook_url                                 = var.slack_webhook_url
  dockerhub_username                                = var.dockerhub_username
  dockerhub_password                                = var.dockerhub_password
  how_out_of_date_are_we_github_token               = var.how_out_of_date_are_we_github_token
  authorized_keys_github_token                      = var.authorized_keys_github_token
  hoodaw_host                                       = var.hoodaw_host
  hoodaw_api_key                                    = var.hoodaw_api_key
  github_actions_secrets_token                      = var.github_actions_secrets_token
  environments_live_reports_s3_bucket               = var.environments_live_reports_s3_bucket

  eks_cluster_name = terraform.workspace
  hoodaw_irsa_enabled = false
}


