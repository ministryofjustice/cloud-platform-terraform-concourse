data "aws_ssm_parameter" "dockerhub_registry_credentials" {
  name = "/cloud-platform/infrastructure/account/dockerhub_credentials"
}
