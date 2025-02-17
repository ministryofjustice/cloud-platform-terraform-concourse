# cloud-platform-terraform-concourse

[![Releases](https://img.shields.io/github/release/ministryofjustice/cloud-platform-terraform-concourse/all.svg?style=flat-square)](https://github.com/ministryofjustice/cloud-platform-terraform-concourse/releases)

This module is not intended for external use outside of the Cloud Platform team. This module is installed on an EKS cluster.

As with the rest of the Cloud Platform components, this module is referenced in [ministryofjustice/cloud-platform-infrastructure/terraform/aws-accounts/cloud-platform-aws/vpc/eks/components/components.tf](https://github.com/ministryofjustice/cloud-platform-infrastructure/blob/main/terraform/aws-accounts/cloud-platform-aws/vpc/eks/components/components.tf).

## Usage

Most of the variables passed into the module are sensitive (secrets), which are encrypted via git-crypt in [cloud-platform-infrastructure](https://github.com/ministryofjustice/cloud-platform-infrastructure).

```hcl
module "concourse" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-concourse?ref=1.10.7"

  concourse_hostname                                = data.terraform_remote_state.cluster.outputs.cluster_domain_name
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
  dockerhub_username                                = var.dockerhub_username
  dockerhub_password                                = var.dockerhub_password
  how_out_of_date_are_we_github_token               = var.how_out_of_date_are_we_github_token
  authorized_keys_github_token                      = var.authorized_keys_github_token
  hoodaw_host                                       = var.hoodaw_host
  hoodaw_api_key                                    = var.hoodaw_api_key
  github_actions_secrets_token                      = var.github_actions_secrets_token
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=4.24.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >=2.6.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | 2.1.3 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >=2.12.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >=3.4.3 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >=4.0.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=4.24.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | >=2.6.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 2.1.3 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >=2.12.1 |
| <a name="provider_random"></a> [random](#provider\_random) | >=3.4.3 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | >=4.0.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_irsa"></a> [irsa](#module\_irsa) | github.com/ministryofjustice/cloud-platform-terraform-irsa | 2.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.iam_access_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_policy.allow_irsa_write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.eks_cluster_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.global_account_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.attach_eks_cluster_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_policy_attachment.attach_global_account_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_policy_attachment.attach_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_user.concourse_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [helm_release.concourse](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.reports_alerts](https://registry.terraform.io/providers/alekc/kubectl/2.1.3/docs/resources/manifest) | resource |
| [kubectl_manifest.service_monitor](https://registry.terraform.io/providers/alekc/kubectl/2.1.3/docs/resources/manifest) | resource |
| [kubernetes_limit_range.concourse](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/limit_range) | resource |
| [kubernetes_limit_range.concourse_main](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/limit_range) | resource |
| [kubernetes_namespace.concourse](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.concourse_main](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_network_policy.concourse_allow_ingress_controllers](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/network_policy) | resource |
| [kubernetes_network_policy.concourse_default](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/network_policy) | resource |
| [kubernetes_network_policy.concourse_main_allow_ingress_controllers](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/network_policy) | resource |
| [kubernetes_network_policy.concourse_main_default](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/network_policy) | resource |
| [kubernetes_network_policy.concourse_prom_scrapping](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/network_policy) | resource |
| [kubernetes_resource_quota.concourse](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/resource_quota) | resource |
| [kubernetes_resource_quota.concourse_main](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/resource_quota) | resource |
| [kubernetes_role_binding.concourse_web](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |
| [kubernetes_secret.cloud_platform_infra_pr_git_access_token](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.concourse_aws_credentials](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.concourse_basic_auth_credentials](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.concourse_main_cp_infrastructure_git_crypt](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.concourse_main_dockerhub](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.concourse_main_environments_git_crypt](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.concourse_main_git_crypt](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.concourse_main_how_out_of_date_are_we_github_token](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.concourse_main_pingdom](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.concourse_main_pr_github_access_token](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.concourse_main_slack](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.concourse_main_slack_hook](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.concourse_main_update_authorized_keys_github_token](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.concourse_tf_auth0_credentials](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.dockerhub_credentials](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.environnments_live_reports_s3_bucket](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.github_actions_secrets_token](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.hoodaw_creds](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.irsa](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [random_password.basic_auth_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.basic_auth_username](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [tls_private_key.host_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_private_key.session_signing_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_private_key.worker_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.allow_irsa_write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.eks_cluster_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.global_account_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_s3_bucket.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Name of Application you are deploying | `string` | `"How Out Of Date Are We"` | no |
| <a name="input_authorized_keys_github_token"></a> [authorized\_keys\_github\_token](#input\_authorized\_keys\_github\_token) | n/a | `any` | n/a | yes |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Area of the MOJ responsible for the service. | `string` | `"Platforms"` | no |
| <a name="input_cloud_platform_infrastructure_git_crypt_key"></a> [cloud\_platform\_infrastructure\_git\_crypt\_key](#input\_cloud\_platform\_infrastructure\_git\_crypt\_key) | n/a | `any` | n/a | yes |
| <a name="input_cloud_platform_infrastructure_pr_git_access_token"></a> [cloud\_platform\_infrastructure\_pr\_git\_access\_token](#input\_cloud\_platform\_infrastructure\_pr\_git\_access\_token) | Variable used to check PR status against cloud-platform-infrastructure repo | `any` | n/a | yes |
| <a name="input_concourse-git-crypt"></a> [concourse-git-crypt](#input\_concourse-git-crypt) | n/a | `any` | n/a | yes |
| <a name="input_concourse_hostname"></a> [concourse\_hostname](#input\_concourse\_hostname) | n/a | `any` | n/a | yes |
| <a name="input_dockerhub_password"></a> [dockerhub\_password](#input\_dockerhub\_password) | Dockerhub password - used to pull images and avoid hitting dockerhub API limits | `any` | n/a | yes |
| <a name="input_dockerhub_username"></a> [dockerhub\_username](#input\_dockerhub\_username) | Dockerhub password - used to pull images and avoid hitting dockerhub API limits | `any` | n/a | yes |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of the EKS cluster | `any` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The type of environment you're deploying to. | `string` | `"production"` | no |
| <a name="input_environments-git-crypt"></a> [environments-git-crypt](#input\_environments-git-crypt) | n/a | `any` | n/a | yes |
| <a name="input_environments_live_reports_s3_bucket"></a> [environments\_live\_reports\_s3\_bucket](#input\_environments\_live\_reports\_s3\_bucket) | S3 bucket for storing apply-live reports | `string` | n/a | yes |
| <a name="input_github_actions_secrets_token"></a> [github\_actions\_secrets\_token](#input\_github\_actions\_secrets\_token) | Github personal access token able to update any MoJ repository. Used to create github actions secrets | `string` | `""` | no |
| <a name="input_github_auth_client_id"></a> [github\_auth\_client\_id](#input\_github\_auth\_client\_id) | n/a | `any` | n/a | yes |
| <a name="input_github_auth_client_secret"></a> [github\_auth\_client\_secret](#input\_github\_auth\_client\_secret) | n/a | `any` | n/a | yes |
| <a name="input_github_org"></a> [github\_org](#input\_github\_org) | n/a | `any` | n/a | yes |
| <a name="input_github_owner"></a> [github\_owner](#input\_github\_owner) | The GitHub organization or individual user account containing the app's code repo. Used by the Github Terraform provider. See: https://user-guide.cloud-platform.service.justice.gov.uk/documentation/getting-started/ecr-setup.html#accessing-the-credentials | `string` | `"ministryofjustice"` | no |
| <a name="input_github_teams"></a> [github\_teams](#input\_github\_teams) | n/a | `any` | n/a | yes |
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | n/a | `any` | n/a | yes |
| <a name="input_hoodaw_api_key"></a> [hoodaw\_api\_key](#input\_hoodaw\_api\_key) | API key to authenticate data posts to https://how-out-of-date-are-we.apps.live-1.cloud-platform.service.justice.gov.uk | `string` | `""` | no |
| <a name="input_hoodaw_host"></a> [hoodaw\_host](#input\_hoodaw\_host) | URL of the 'how-out-of-date-are-we' web application | `string` | `""` | no |
| <a name="input_hoodaw_irsa_enabled"></a> [hoodaw\_irsa\_enabled](#input\_hoodaw\_irsa\_enabled) | Enable IRSA for hoodaw | `any` | n/a | yes |
| <a name="input_how_out_of_date_are_we_github_token"></a> [how\_out\_of\_date\_are\_we\_github\_token](#input\_how\_out\_of\_date\_are\_we\_github\_token) | n/a | `any` | n/a | yes |
| <a name="input_infrastructure_support"></a> [infrastructure\_support](#input\_infrastructure\_support) | The team responsible for managing the infrastructure. Should be of the form team-email. | `string` | `"platforms@digital.justice.gov.uk"` | no |
| <a name="input_is_production"></a> [is\_production](#input\_is\_production) | n/a | `string` | `"true"` | no |
| <a name="input_limit_active_tasks"></a> [limit\_active\_tasks](#input\_limit\_active\_tasks) | the maximum number of tasks a concourse worker can run | `number` | `2` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | n/a | `string` | `"concourse-main"` | no |
| <a name="input_pingdom_api_key"></a> [pingdom\_api\_key](#input\_pingdom\_api\_key) | n/a | `any` | n/a | yes |
| <a name="input_pingdom_api_token"></a> [pingdom\_api\_token](#input\_pingdom\_api\_token) | n/a | `any` | n/a | yes |
| <a name="input_pingdom_password"></a> [pingdom\_password](#input\_pingdom\_password) | n/a | `any` | n/a | yes |
| <a name="input_pingdom_user"></a> [pingdom\_user](#input\_pingdom\_user) | n/a | `any` | n/a | yes |
| <a name="input_slack_bot_token"></a> [slack\_bot\_token](#input\_slack\_bot\_token) | n/a | `any` | n/a | yes |
| <a name="input_slack_channel"></a> [slack\_channel](#input\_slack\_channel) | Team slack channel to use if we need to contact your team | `string` | `"cloud-platform"` | no |
| <a name="input_slack_hook_id"></a> [slack\_hook\_id](#input\_slack\_hook\_id) | n/a | `any` | n/a | yes |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | n/a | `any` | n/a | yes |
| <a name="input_team_name"></a> [team\_name](#input\_team\_name) | The name of your development team | `string` | `"webops"` | no |
| <a name="input_tf_provider_auth0_client_id"></a> [tf\_provider\_auth0\_client\_id](#input\_tf\_provider\_auth0\_client\_id) | Client ID (prod) for auth0, it is used by divergence pipelines | `any` | n/a | yes |
| <a name="input_tf_provider_auth0_client_secret"></a> [tf\_provider\_auth0\_client\_secret](#input\_tf\_provider\_auth0\_client\_secret) | Client Secret (prod) for auth0, it is used by divergence pipelines | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
