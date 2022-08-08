resource "aws_secretsmanager_secret" "concourse-test-dockerhub-username" {
  name = "/concourse/main/build-image-test/test_dockerhub_user"
  description = "concourse secrets test - dockerhub username"

}

resource "aws_secretsmanager_secret" "concourse-test-dockerhub-token" {
  name = "/concourse/main/build-image-test/test_dockerhub_token"
  description = "concourse secrets test - dockerhub token"
}