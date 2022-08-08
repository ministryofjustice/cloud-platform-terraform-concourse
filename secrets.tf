resource "aws_secretsmanager_secret" "concourse-test-dockerhub-username" {
  name = "test_dockerhub_user"
}

resource "aws_secretsmanager_secret" "concourse-test-dockerhub-token" {
  name = "test_dockerhub_token"
}