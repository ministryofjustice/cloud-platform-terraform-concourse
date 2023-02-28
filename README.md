# cloud-platform-terraform-concourse

[![Releases](https://img.shields.io/github/release/ministryofjustice/cloud-platform-terraform-concourse/all.svg?style=flat-square)](https://github.com/ministryofjustice/cloud-platform-terraform-concourse/releases)

This module is not intended for external use outside of the Cloud Platform team. This module is installed on an EKS cluster.

As with the rest of the Cloud Platform components, this module is referenced in [ministryofjustice/cloud-platform-infrastructure/terraform/aws-accounts/cloud-platform-aws/vpc/eks/components/components.tf](https://github.com/ministryofjustice/cloud-platform-infrastructure/blob/main/terraform/aws-accounts/cloud-platform-aws/vpc/eks/components/components.tf).

## Usage

Most of the variables passed into the module are sensitive (secrets), which are encrypted via git-crypt in [cloud-platform-infrastructure](https://github.com/ministryofjustice/cloud-platform-infrastructure).

<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS -->
