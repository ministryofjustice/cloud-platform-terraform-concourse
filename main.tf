locals {
  # This is the list of Route53 Hosted Zones in the DSD account that
  # cert-manager and external-dns will be given access to.
  live_workspace = "manager"
  live_domain    = "cloud-platform.service.justice.gov.uk"
}

/*
 * Generate the `values.yaml` configuration for the concourse helm chart.
 *
 */

resource "tls_private_key" "host_key" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_private_key" "session_signing_key" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_private_key" "worker_key" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "random_password" "basic_auth_username" {
  length  = 16
  special = false
}

resource "random_password" "basic_auth_password" {
  length  = 32
  special = false
}

locals {
  basic_username = "secret${random_password.basic_auth_username.result}"
  basic_password = "secret${random_password.basic_auth_password.result}"
}

######################
# Kubernetes Secrets #
######################

resource "kubernetes_secret" "concourse_aws_credentials" {
  depends_on = [helm_release.concourse]

  metadata {
    name      = "aws-creds"
    namespace = kubernetes_namespace.concourse_main.id
  }

  data = {
    access-key-id     = aws_iam_access_key.iam_access_key.id
    secret-access-key = aws_iam_access_key.iam_access_key.secret
  }
}

resource "kubernetes_secret" "cloud_platform_admin_user_creds" {
  depends_on = [helm_release.concourse]

  metadata {
    name      = "cloud-platform-admin-user-creds"
    namespace = kubernetes_namespace.concourse_main.id
  }

  data = {
    access-key-id     = aws_iam_access_key.cloud_platform_admin_user_access_key.id
    secret-access-key = aws_iam_access_key.cloud_platform_admin_user_access_key.secret
  }
}

resource "kubernetes_secret" "concourse_basic_auth_credentials" {
  depends_on = [helm_release.concourse]

  metadata {
    name      = "concourse-basic-auth"
    namespace = kubernetes_namespace.concourse_main.id
  }

  data = {
    username = local.basic_username
    password = local.basic_password
  }
}

resource "kubernetes_secret" "concourse_tf_auth0_credentials" {
  depends_on = [helm_release.concourse]

  metadata {
    name      = "concourse-tf-auth0-credentials"
    namespace = kubernetes_namespace.concourse_main.id
  }

  data = {
    client-id     = var.tf_provider_auth0_client_id
    client_secret = var.tf_provider_auth0_client_secret
  }
}

resource "kubernetes_secret" "concourse_main_cp_infrastructure_git_crypt" {
  metadata {
    name      = "cloud-platform-infrastructure-git-crypt"
    namespace = kubernetes_namespace.concourse_main.id
  }

  data = {
    key = var.cloud_platform_infrastructure_git_crypt_key
  }
}

resource "kubernetes_secret" "cloud_platform_infra_pr_git_access_token" {
  metadata {
    name      = "cloud-platform-infrastructure-pr-git-access-token"
    namespace = kubernetes_namespace.concourse_main.id
  }

  data = {
    value = var.cloud_platform_infrastructure_pr_git_access_token
  }
}

resource "kubernetes_secret" "dockerhub_credentials" {
  metadata {
    name      = "dockerhub-credentials"
    namespace = kubernetes_namespace.concourse.id
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = <<DOCKER
{
  "auths": {
    "https://index.docker.io/v1": {
      "auth": "${base64encode("${var.dockerhub_username}:${var.dockerhub_password}")}"
    }
  }
}
DOCKER
  }
}

# GitHub personal access token for the how-out-of-date-are-we updater concourse pipeline
resource "kubernetes_secret" "concourse_main_how_out_of_date_are_we_github_token" {
  depends_on = [helm_release.concourse]

  metadata {
    name      = "how-out-of-date-are-we-github-token"
    namespace = kubernetes_namespace.concourse_main.id
  }

  data = {
    token = var.how_out_of_date_are_we_github_token
  }
}

# SonarQube token / host used by concourse to scan the github repos
resource "kubernetes_secret" "sonarqube_creds" {
  depends_on = [helm_release.concourse]

  metadata {
    name      = "sonarqube-creds"
    namespace = kubernetes_namespace.concourse_main.id
  }

  data = {
    token = var.sonarqube_token
    host  = var.sonarqube_host
  }
}

# GitHub personal access token for the update-authorized-keys concourse pipeline
resource "kubernetes_secret" "concourse_main_update_authorized_keys_github_token" {
  depends_on = [helm_release.concourse]

  metadata {
    name      = "authorized-keys-github-token"
    namespace = kubernetes_namespace.concourse_main.id
  }

  data = {
    token = var.authorized_keys_github_token
  }
}

# How out of date are we API token, used by concourse jobs which post JSON to the web app.
resource "kubernetes_secret" "hoodaw_creds" {
  depends_on = [
    helm_release.concourse
  ]

  metadata {
    name      = "hoodaw-creds"
    namespace = kubernetes_namespace.concourse_main.id
  }

  data = {
    api_key  = var.hoodaw_api_key
    hostname = var.hoodaw_host
  }
}

resource "helm_release" "concourse" {
  name          = "concourse"
  namespace     = kubernetes_namespace.concourse.id
  repository    = "https://concourse-charts.storage.googleapis.com/"
  chart         = "concourse"
  version       = "16.1.1"
  recreate_pods = true

  values = [templatefile("${path.module}/templates/values.yaml", {

    concourse_hostname = terraform.workspace == local.live_workspace ? format("%s.%s", "concourse", local.live_domain) : format(
      "%s.%s",
      "concourse.apps",
      var.concourse_hostname,
    )
    basic_username            = local.basic_username
    basic_password            = local.basic_password
    github_auth_client_id     = var.github_auth_client_id
    github_auth_client_secret = var.github_auth_client_secret
    github_org                = var.github_org
    github_teams              = var.github_teams
    host_key_priv             = indent(4, tls_private_key.host_key.private_key_pem)
    host_key_pub              = tls_private_key.host_key.public_key_openssh
    session_signing_key_priv  = indent(4, tls_private_key.session_signing_key.private_key_pem)
    worker_key_priv           = indent(4, tls_private_key.worker_key.private_key_pem)
    worker_key_pub            = tls_private_key.worker_key.public_key_openssh
  })]

  depends_on = [
    var.dependence_prometheus,
    kubernetes_secret.dockerhub_credentials
  ]

  lifecycle {
    ignore_changes = [keyring]
  }
}

########################
# Namespace: concourse #
########################

resource "kubernetes_namespace" "concourse" {
  metadata {
    name = "concourse"

    labels = {
      "cloud-platform.justice.gov.uk/environment-name" = "production"
      "cloud-platform.justice.gov.uk/is-production"    = "true"
    }

    annotations = {
      "cloud-platform.justice.gov.uk/application"   = "Concourse CI"
      "cloud-platform.justice.gov.uk/business-unit" = "cloud-platform"
      "cloud-platform.justice.gov.uk/owner"         = "Cloud Platform: platforms@digital.justice.gov.uk"
      "cloud-platform.justice.gov.uk/source-code"   = "https://github.com/ministryofjustice/cloud-platform-concourse"
    }
  }
}

resource "kubernetes_limit_range" "concourse" {
  metadata {
    name      = "limitrange"
    namespace = kubernetes_namespace.concourse.id
  }

  spec {
    limit {
      type = "Container"
      default = {
        cpu    = "2"
        memory = "4000Mi"
      }
      default_request = {
        cpu    = "100m"
        memory = "100Mi"
      }
    }
  }
}

resource "kubernetes_resource_quota" "concourse" {
  metadata {
    name      = "namespace-quota"
    namespace = kubernetes_namespace.concourse.id
  }
  spec {
    hard = {
      pods = 50
    }
  }
}

resource "kubernetes_network_policy" "concourse_default" {
  metadata {
    name      = "default"
    namespace = kubernetes_namespace.concourse.id
  }

  spec {
    pod_selector {}

    ingress {
      from {
        pod_selector {}
      }
    }

    policy_types = ["Ingress"]
  }
}

resource "kubernetes_network_policy" "concourse_allow_ingress_controllers" {
  metadata {
    name      = "allow-ingress-controllers"
    namespace = kubernetes_namespace.concourse.id
  }

  spec {
    pod_selector {}

    ingress {
      from {
        namespace_selector {
          match_labels = {
            component = "ingress-controllers"
          }
        }
      }
    }

    policy_types = ["Ingress"]
  }
}

resource "kubernetes_network_policy" "concourse_prom_scrapping" {
  metadata {
    name      = "allow-prometheus-scraping"
    namespace = kubernetes_namespace.concourse.id
  }

  spec {
    pod_selector {
      match_labels = {
        app = "concourse-web"
      }
    }

    ingress {
      from {
        namespace_selector {
          match_labels = {
            component = "monitoring"
          }
        }
      }
    }

    policy_types = ["Ingress"]
  }
}

#############################
# Namespace: concourse-main #
#############################

resource "kubernetes_namespace" "concourse_main" {
  metadata {
    name = "concourse-main"

    labels = {
      "cloud-platform.justice.gov.uk/environment-name" = "production"
      "cloud-platform.justice.gov.uk/is-production"    = "true"
    }

    annotations = {
      "cloud-platform.justice.gov.uk/application"   = "Concourse"
      "cloud-platform.justice.gov.uk/business-unit" = "cloud-platform"
      "cloud-platform.justice.gov.uk/owner"         = "Cloud Platform: platforms@digital.justice.gov.uk"
      "cloud-platform.justice.gov.uk/source-code"   = "https://github.com/ministryofjustice/cloud-platform-concourse"
    }
  }
}

# Rolebinding between concourse-web serviveaccount and ClusterRole concourse-web to enable pipelines access secrets from namespace concourse-main
resource "kubernetes_role_binding" "concourse_web" {
  metadata {
    name      = "concourse-web-rolebinding"
    namespace = "concourse-main"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "concourse-web"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "concourse-web"
    namespace = "concourse"
  }
}


resource "kubernetes_limit_range" "concourse_main" {
  metadata {
    name      = "limitrange"
    namespace = kubernetes_namespace.concourse_main.id
  }

  spec {
    limit {
      type = "Container"
      default = {
        cpu    = "1"
        memory = "1000Mi"
      }
      default_request = {
        cpu    = "10m"
        memory = "100Mi"
      }
    }
  }
}


resource "kubernetes_resource_quota" "concourse_main" {
  metadata {
    name      = "namespace-quota"
    namespace = kubernetes_namespace.concourse_main.id
  }
  spec {
    hard = {
      pods = 50
    }
  }
}

resource "kubernetes_network_policy" "concourse_main_default" {
  metadata {
    name      = "default"
    namespace = kubernetes_namespace.concourse_main.id
  }

  spec {
    pod_selector {}

    ingress {
      from {
        pod_selector {}
      }
    }

    policy_types = ["Ingress"]
  }
}

resource "kubernetes_network_policy" "concourse_main_allow_ingress_controllers" {
  metadata {
    name      = "allow-ingress-controllers"
    namespace = kubernetes_namespace.concourse_main.id
  }

  spec {
    pod_selector {}

    ingress {
      from {
        namespace_selector {
          match_labels = {
            component = "ingress-controllers"
          }
        }
      }
    }

    policy_types = ["Ingress"]
  }
}

resource "kubernetes_secret" "concourse_main_slack_hook" {

  metadata {
    name      = "slack-hook-id"
    namespace = kubernetes_namespace.concourse_main.id
  }

  data = {
    value = var.slack_hook_id
  }
}

resource "kubernetes_secret" "concourse_main_git_crypt" {

  metadata {
    name      = "cloud-platform-concourse-git-crypt"
    namespace = kubernetes_namespace.concourse_main.id
  }

  data = {
    key = var.concourse-git-crypt
  }
}

resource "kubernetes_secret" "concourse_main_environments_git_crypt" {

  metadata {
    name      = "cloud-platform-environments-git-crypt"
    namespace = kubernetes_namespace.concourse_main.id
  }

  data = {
    key = var.environments-git-crypt
  }
}

resource "kubernetes_secret" "concourse_main_pr_github_access_token" {

  metadata {
    name      = "cloud-platform-environments-pr-git-access-token"
    namespace = kubernetes_namespace.concourse_main.id
  }

  data = {
    value = var.github_token
  }
}

resource "kubernetes_secret" "concourse_main_pingdom" {

  metadata {
    name      = "cloud-platform-environments-pingdom"
    namespace = kubernetes_namespace.concourse_main.id
  }

  data = {
    pingdom_user      = var.pingdom_user
    pingdom_password  = var.pingdom_password
    pingdom_api_key   = var.pingdom_api_key
    pingdom_api_token = var.pingdom_api_token
  }
}

resource "kubernetes_secret" "concourse_main_dockerhub" {
  metadata {
    name      = "ministryofjustice-dockerhub"
    namespace = kubernetes_namespace.concourse_main.id
  }

  data = {
    dockerhub_username = var.dockerhub_username
    dockerhub_password = var.dockerhub_password
  }
}

resource "kubernetes_secret" "github_actions_secrets_token" {
  metadata {
    name      = "github-actions-secrets-token"
    namespace = kubernetes_namespace.concourse_main.id
  }

  data = {
    token = var.github_actions_secrets_token
  }
}

resource "kubectl_manifest" "service_monitor" {
  yaml_body = file("${path.module}/resources/concourse-servicemonitor.yaml")
}
