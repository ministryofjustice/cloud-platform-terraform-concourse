module "iam_assumable_role_admin" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.13.0"
  create_role                   = true
  role_name                     = "${terraform.workspace}-concourse-role"
  provider_url                  = var.eks_cluster_oidc_issuer_url
  role_policy_arns              = [length(aws_iam_policy.concourse) >= 1 ? aws_iam_policy.concourse.arn : ""]
  oidc_fully_qualified_subjects = ["system:serviceaccount:concourse:concourse-web"]
}

resource "aws_iam_policy" "concourse" {

  name_prefix = "${terraform.workspace}-concourse"
  description = "Concourse Policy to allow access to secrets manager"
  policy      = data.aws_iam_policy_document.concourse_irsa.json
}

data "aws_iam_policy_document" "concourse_irsa" {
  /* Secret Manager permissions */
  statement {
    actions = [
      "secretsmanager:ListSecrets",
    ]

    resources = [
      "*",
    ]
  }
  statement {
    actions = [
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetSecretValue",
    ]

    resources = [
      "arn:aws:secretsmanager:*:*:secret:/concourse/main/*",
    ]
  }
  /* End of Secret Manager permissions */ 
}