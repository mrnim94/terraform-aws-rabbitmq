variable "create_security_group" {
  type    = bool
  default = false
}

variable "security_group_name" {
  type    = string
  default = "RabbitMQ security group name."
}

variable "security_group_description" {
  type    = string
  default = "RabbitMQ security group description."
}

variable "vpc_id" {
  description = "ID of the VPC where to create security group"
  type        = string
  default     = null
}

variable "ingress_with_cidr_blocks" {
  type        = list(map(string))
  default     = []
  description = <<-EOT
    List of ingress rules to create where 'cidr_blocks' is used
    EOT
}