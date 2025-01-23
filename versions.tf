terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.24.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">=2.6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.12.1"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = "2.1.3"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3.4.3"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">=4.0.3"
    }
  }
  required_version = ">= 1.2.5"
}
