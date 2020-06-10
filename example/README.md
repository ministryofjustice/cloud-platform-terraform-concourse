# Example AWS Concourse Installation / Configuration

This module is for internal use and currently not intended for teams to use. 

Furthermore this module will be installed on an EKS cluster. As with the rest of the components this module will be referenced from 'cloud-platform-infrastructure/terraform/cloud-platform-eks/components/components.tf'

This example is designed to be used in the [cloud-platform-infrastructure](https://github.com/ministryofjustice/cloud-platform-infrastructure/) repository.


## Usage

As most of the variables passed into the module are sensitive (secrets) then they need to reside in a file that is encrypted (git-crypt). The values of these variables are therefore placed in the existing encrypted file 'terrraform.tfvars' under '.../components/terraform.tfvars'


example of the module's usage is as follows:

module "concourse" {

  source = "github.com/ministryofjustice/cloud-platform-terraform-concourse?ref=v1.0"
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
 
}