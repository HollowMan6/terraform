variable "owner" {
  type        = string
  default     = "enclaive"
  description = "Name to be used in the Owner tag of the AWS resources"
}

variable "prefix" {
  type        = string
  default     = "enclaive"
  description = "The prefix will precede all the resources to be created for easy identification"
}

variable "aws_region" {
  type        = string
  default     = "eu-west-1"
  description = "AWS region to be used in the deployment"
}

variable "k8s_version" {
  type        = string
  default     = "1.28.0"
  description = "Kubernetes to be used in the deployment"
}

variable "containerd_version" {
  type        = string
  default     = "1.7.3"
  description = "Containerd version to be used in the deployment"
}

variable "runc_version" {
  type        = string
  default     = "1.1.9"
  description = "Runc version to be used in the deployment"
}

variable "calico_version" {
  type        = string
  default     = "3.26.1"
  description = "Calico version to be used in the deployment"
}

variable "k9s_version" {
  type        = string
  default     = "0.27.4"
  description = "K9s version to be used in the deployment"
}

variable "tigera_scanner_version" {
  type        = string
  default     = "3.16.1-11"
  description = "Tigera scanner version to be used in the deployment"
}

variable "cp_instance_type" {
  type        = string
  default     = "c6a.large"
  description = "Instance type used for control-plane node EC2 instance"
}

variable "wk_instance_type" {
  type        = string
  default     = "c6a.large"
  description = "Instance type used for worker node EC2 instance"
}

variable "wk_instance_count" {
  type        = number
  default     = 1
  description = "Number of Instances for worker node(s) EC2 instance"
}
