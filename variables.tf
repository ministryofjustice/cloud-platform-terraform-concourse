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