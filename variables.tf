
variable "github_auth_client_id" {}      
variable "github_auth_client_secret" {}    
variable "github_org" {} 
variable "github_teams" {}                  
variable "tf_provider_auth0_client_id" {}              
variable "tf_provider_auth0_client_secret" {}          
variable "cloud_platform_infrastructure_git_crypt_key" {}
variable "slack_hook_id" {}
variable "concourse-git-crypt" {}   
variable "environments-git-crypt" {}
variable "github_token" {}
variable "pingdom_user" {}
variable "pingdom_password" {}
variable "pingdom_api_key" {}
variable "dockerhub_username" {}
variable "dockerhub_access_token" {}
variable "how_out_of_date_are_we_github_token" {} 
variable "concourse_hostname_prefix" {}

variable "rds_storage" {
  default     = "50"
  description = "RDS storage size in GB"
}

variable "rds_postgresql_version" {
  default     = "10.6"
  description = "Version of PostgreSQL RDS to use"
}

variable "rds_instance_class" {
  default     = "db.t2.micro"
  description = "RDS instance class"
}

variable "concourse_image_tag" {
  default     = "5.8.0"
  description = "The docker image tag to use"
}

variable "concourse_chart_version" {
  default     = "9.0.0"
  description = "The Helm chart version"
}

variable "vpc_name" {
  default     = ""
  description = "The VPC where deployment is going to happen"
}

variable "cluster_name" {
  default     = ""
  description = "The cluster name where is going to be deployed"
}

variable "kops_or_eks" {
  default     = "kops"
  description = "For kops state in cloud-platform/$cluster/terraform.tfstate for EKS state in: cloud-platform-eks/$cluster/terraform.tfstate"
}

variable "is_prod" {
  type        = bool
  default     = false
  description = "Is it production CI?"
}