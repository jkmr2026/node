variable "vpc_id"             { type = string }
variable "env_name"           { type = string }
variable "desired_nodes"      { type = number }
variable "max_nodes"          { type = number }
variable "private_subnet_ids" { type = list(string) }

variable "cluster_name" {
  description = "Optional override for EKS cluster name; defaults to <env_name>-eks"
  type        = string
  default     = ""
}

variable "create_kms_key" {
  description = "Whether to create a new KMS key for cluster encryption"
  type        = bool
  default     = true
}

variable "kms_key_alias" {
  description = "Optional alias for the KMS key when create_kms_key is true"
  type        = string
  default     = ""
}

variable "existing_kms_key_arn" {
  description = "Use an existing KMS key ARN when create_kms_key is false"
  type        = string
  default     = null
}

variable "create_cloudwatch_log_group" {
  description = "Whether to create the CloudWatch Log Group for control plane logs"
  type        = bool
  default     = true
}
