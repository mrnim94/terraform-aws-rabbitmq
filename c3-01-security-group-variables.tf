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
    Example:
    ```
    ingress_with_cidr_blocks = [
      {
        from_port   = 8080
        to_port     = 8090
        protocol    = "tcp"
        description = "User-service ports"
        cidr_blocks = "10.10.0.0/16"
      },
      {
        rule        = "postgresql-tcp"
        cidr_blocks = "0.0.0.0/0"
      },
    ]
    ```
    EOT
}