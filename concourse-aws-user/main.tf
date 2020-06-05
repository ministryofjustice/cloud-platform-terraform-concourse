
variable "aws_profile" {}

provider "aws" {
  profile = "moj-cp"
  // AWS region does not matter since we're only dealing with IAM but is
  // required for the provider.
  region = "eu-west-2"
}

data "aws_caller_identity" "current" {
}

resource "aws_iam_user" "concourse_user" {
  name = "${terraform.workspace}-concourse"
  path = "/cloud-platform/"
}

resource "aws_iam_access_key" "iam_access_key" {
  user = aws_iam_user.concourse_user.name
}

data "aws_iam_policy_document" "policy" {
  statement {
    actions = [
      "s3:*",
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }

  statement {
    actions = [
      "iam:GetUser",
      "iam:CreateUser",
      "iam:DeleteUser",
      "iam:UpdateUser",
      "iam:ListAccessKeys",
      "iam:CreateAccessKey",
      "iam:DeleteAccessKey",
      "iam:PutUserPolicy",
      "iam:GetUserPolicy",
      "iam:DeleteUserPolicy",
      "iam:ListGroupsForUser",
      "iam:PutUserPermissionsBoundary",
      "iam:GetPolicy",
      "iam:ListEntitiesForPolicy",
      "iam:GetPolicyVersion",
      "iam:DeleteUserPermissionsBoundary",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/system/*",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/*",
    ]
  }

  statement {
    actions = [
      "iam:GetUser",
      "iam:ListAccessKeys",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/*",
    ]
  }


  statement {
    actions = [
      "ecr:*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "rds:*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "kms:*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "elasticache:*",
    ]

    resources = [
      "*",
    ]
  }

  # Due to build-test-cluster pipeline we need to give moe privileges to the concourse user
  # in order to create/destroy vpc, resources and roles. 

  statement {
    actions = [
      "ec2:*",
      "acm:RequestCertificate",

      "iam:CreateRole",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:GetRole",
      "iam:PutRolePolicy",
      "iam:GetRolePolicy",
      "iam:TagRole",
      "iam:ListInstanceProfilesForRole",
      "iam:ListPolicyVersions",
      "iam:DeletePolicyVersion",
      "iam:DeleteRolePolicy",
      "iam:DeleteRole",
      "iam:DeletePolicy",

      "iam:CreateInstanceProfile",     # terraform/cloud-platform (bastion module)
      "iam:AddRoleToInstanceProfile",  # terraform/cloud-platform (bastion module)
      "iam:PassRole",                  # terraform/cloud-platform
      "autoscaling:*",                 # kops create
      "route53:ListHostedZonesByName", # kops create
      "elasticloadbalancing:*",        # kops create
      "iam:UpdateAssumeRolePolicy"     # because of integration tests ("is not authorized to perform: iam:UpdateAssumeRolePolicy on resource: role integration-test-kiam-iam-role)
    ]

    resources = [
      "*",
    ]
  }

  # In order to create the kubeadmin file using: 
  # aws eks --region REGION update-kubeconfig --name CLUSTER
  statement {
    actions = [
      "eks:DescribeCluster",
      "iam:GetOpenIDConnectProvider",
    ]

    resources = [
      "*",
    ]
  }


  statement {
    actions = [
      "dynamodb:*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "es:*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "application-autoscaling:RegisterScalableTarget",
      "application-autoscaling:DescribeScalableTargets",
      "application-autoscaling:PutScalingPolicy",
      "application-autoscaling:DescribeScalingPolicies",
      "application-autoscaling:DeleteScalingPolicy",
      "application-autoscaling:DeregisterScalableTarget"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "iam:CreateRole",
      "iam:GetRole",
      "iam:PutRolePolicy",
      "iam:GetRolePolicy",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*-autoscaler",
    ]
  }

  statement {
    actions = [
      "iam:CreateRole",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:GetRole",
      "iam:PutRolePolicy",
      "iam:GetRolePolicy",
      "iam:TagRole",
      "iam:ListInstanceProfilesForRole",
      "iam:DeleteRolePolicy",
      "iam:DeleteRole",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/cloud-platform-*",
    ]
  }

  statement {
    actions = [
      "iam:CreatePolicy",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/cloud-platform-*",
    ]
  }

  # This is because of cloud-platform-infrastructure/terraform/global-resources/iam
  statement {
    actions = [
      "iam:ListAccountAliases",
      "iam:GetGroup",
      "iam:ListAttachedGroupPolicies",
    ]

    resources = [
      "*",
    ]
  }


  statement {
    actions = [
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateNetworkInterface",
      "ec2:CreateSecurityGroup",
      "ec2:DeleteNetworkInterface",
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteNetworkInterfacePermission",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeRouteTables",
      "ec2:DescribeSecurityGroupReferences",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeStaleSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs",
      "ec2:DetachNetworkInterface",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
      "ec2:UpdateSecurityGroupRuleDescriptionsIngress",
      "ec2:TerminateInstances",
      # Required by terraform-aws module
      "ec2:Describe*",
      "autoscaling:Describe*",
      # In order to run the EKS divergence and build EKS test clusters:
      "eks:*",
    ]

    resources = [
      "*",
    ]
  }

  # Roles to Create/Edit/Delete MQ.
  statement {
    actions = [
      "mq:*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "ec2:CreateNetworkInterfacePermission",
      "ec2:DescribeNetworkInterfacePermissions",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "StringEquals"
      variable = "ec2:AuthorizedService"

      values = [
        "mq.amazonaws.com",
      ]
    }
  }

  # Roles to Create/Edit/Delete Route53 Zone.
  statement {
    actions = [
      "route53:CreateHostedZone",
      "route53:ListHostedZones",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "route53:GetChange",
    ]

    resources = [
      "arn:aws:route53:::change/*",
    ]
  }

  statement {
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ChangeTagsForResource",
      "route53:DeleteHostedZone",
      "route53:GetHostedZone",
      "route53:ListResourceRecordSets",
      "route53:ListTagsForResource",
      "route53:UpdateHostedZoneComment",
    ]

    resources = [
      "arn:aws:route53:::hostedzone/*",
    ]
  }

  statement {
    actions = [
      "sns:*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "acm:DescribeCertificate",
      "acm:ListTagsForCertificate",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "sqs:*",
    ]

    resources = [
      "*",
    ]
  }

  /*

    The permissions below enable the concourse pipeline to run the cluster
    integration tests.  The kiam tests depend on an AWS role, which the tests will
    try to create if it doesn't exist. The ability to create roles is quite
    powerful, so it is not granted here. This means, if the concourse pipeline runs
    the integration tests and the required role is not present, they will fail,
    with an error about being unable to create a role.  The fix for this is for a
    member of the webops team to run the tests once, using their AWS credentials.
    This will create the role, and leave it in place, so that subsequent pipeline
    runs will succeed.

   */

  statement {
    actions = [
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListAttachedRolePolicies",
      "iam:ListRoles",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*",
    ]
  }
  statement {
    actions = [
      "iam:ListPolicies",
      "iam:GetInstanceProfile"
    ]

    resources = [
      "*",
    ]
  }
  /* End of permissions for concourse pipeline integration tests */
}

resource "aws_iam_policy" "policy" {
  name        = "${terraform.workspace}-concourse-user-policy"
  path        = "/cloud-platform/"
  policy      = data.aws_iam_policy_document.policy.json
  description = "Policy for ${terraform.workspace}-concourse"
}

resource "aws_iam_policy_attachment" "attach_policy" {
  name       = "attached-policy"
  users      = [aws_iam_user.concourse_user.name]
  policy_arn = aws_iam_policy.policy.arn
}

output "id" {
  value = aws_iam_access_key.iam_access_key.id
}

output "secret" {
  value = aws_iam_access_key.iam_access_key.secret
}

