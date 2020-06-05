
terraform {
  backend "s3" {
    bucket               = "cloud-platform-terraform-state"
    region               = "eu-west-1"
    key                  = "terraform.tfstate"
    workspace_key_prefix = "cloud-platform-concourse"
  }
  required_version = ">= 0.12"
}


data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "cloud-platform-terraform-state"
    region = "eu-west-1"
    key    = "cloud-platform-network/${local.vpc}/terraform.tfstate"
  }
}
  
data "terraform_remote_state" "cluster" {
  backend = "s3"

  config = {
    bucket = "cloud-platform-terraform-state"
    region = "eu-west-1"
    key    = "${local.state_location}/${local.cluster}/terraform.tfstate"
  }
}


##########
# Locals #
##########

locals {
  # This is the list of Route53 Hosted Zones in the DSD account that
  # cert-manager and external-dns will be given access to.
  live_workspace = "manager"
  vpc            = var.vpc_name == "" ? terraform.workspace : var.vpc_name
  cluster        = var.cluster_name == "" ? terraform.workspace : var.cluster_name
  state_location = var.kops_or_eks == "kops" ? "cloud-platform" : "cloud-platform-eks"
  rds_name       = var.is_prod ? "ci" : "${terraform.workspace}-concourse"

  live_domain = "cloud-platform.service.justice.gov.uk"
}

provider "aws" {
  region = "eu-west-1"
}

# To be use in case the resources need to be created in London
provider "aws" {
  profile = "moj-cp"
  alias  = "london"
  region = "eu-west-2"
}


# To be use in case the resources need to be created in Ireland
provider "aws" {
  alias  = "ireland"
  region = "eu-west-1"
}

provider "helm" {
  version = "1.0.0"
  kubernetes {
  }
}



