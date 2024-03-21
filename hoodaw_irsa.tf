module "irsa" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-irsa?ref=2.0.0"
  count = hoodaw_irsa_enabled ? 1 : 0

  # EKS configuration
  eks_cluster_name = var.eks_cluster_name

  # IRSA configuration
  service_account_name = "hoodaw-${var.environment}"
  namespace            = var.hoodaw_namespace
  role_policy_arns     = {
    s3 = aws_iam_policy.allow_irsa_write.arn
  }

  # Tags
  business_unit          = var.business_unit
  application            = var.application
  is_production          = var.is_production
  team_name              = var.team_name
  environment_name       = var.environment
  infrastructure_support = var.infrastructure_support
}

resource "kubernetes_secret" "irsa" {
  count = hoodaw_irsa_enabled ? 1 : 0
  metadata {
    name      = "hoodaw-write-irsa"
    namespace = var.namespace
  }
  data = {
    role           = module.irsa.role_name
    serviceaccount = module.irsa.service_account.name
  }
}

resource "aws_iam_policy" "allow_irsa_write" {
  count = hoodaw_irsa_enabled ? 1 : 0
  name        = "cloud-platform-hoodaw-write"
  path        = "/cloud-platform/"
  policy      = data.aws_iam_policy_document.allow_irsa_write.json
  description = "Allow IRSA to write to the S3 bucket for the hoodaw application"
}

data "aws_iam_policy_document" "allow_irsa_write" {
  count = hoodaw_irsa_enabled ? 1 : 0
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      data.aws_s3_bucket.bucket.arn,
      "${data.aws_s3_bucket.bucket.arn}/*",
    ]
  }
}

data "aws_s3_bucket" "bucket" {
  bucket = "cloud-platform-hoodaw-reports"
}