
terraform {
  backend "s3" {
    bucket               = "cloud-platform-3eb15c4d44e5a2ba686a86b384d221cd"
    region               = "eu-west-2"
    key                  = "terraform.tfstate"
    workspace_key_prefix = "cloud-platform-concourse"
  }
  required_version = ">= 0.12"
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



