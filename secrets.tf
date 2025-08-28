
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

resource "kubernetes_secret" "concourse_main_slack" {

  metadata {
    name      = "cloud-platform-environments-slack"
    namespace = kubernetes_namespace.concourse_main.id
  }

  data = {
    slack_bot_token   = var.slack_bot_token
    slack_webhook_url = var.slack_webhook_url
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

resource "kubernetes_secret" "environnments_live_reports_s3_bucket" {
  metadata {
    name      = "environments-live-reports-s3-bucket"
    namespace = kubernetes_namespace.concourse_main.id
  }

  data = {
    value = var.environments_live_reports_s3_bucket
  }
}

resource "kubernetes_secret" "github_cloud_platform_concourse_bot_app_id" {
    metadata {
    name      = "github_cloud_platform_concourse_bot_app_id"
    namespace = kubernetes_namespace.concourse_main.id
    }
    data = {
        value = var.github_cloud_platform_concourse_bot_app_id
  }
}

resource "kubernetes_secret" "github_cloud_platform_concourse_bot_installation_id" {
    metadata {
    name      = "github_cloud_platform_concourse_bot_installation_id"
    namespace = kubernetes_namespace.concourse_main.id
    }
    data = {
        value = var.github_cloud_platform_concourse_bot_installation_id
  }
}

resource "kubernetes_secret" "github_cloud_platform_concourse_bot_pem_file" {
    metadata {
    name      = "github_cloud_platform_concourse_bot_pem_file"
    namespace = kubernetes_namespace.concourse_main.id
    }
    data = {
        value = var.github_cloud_platform_concourse_bot_pem_file
  }
}