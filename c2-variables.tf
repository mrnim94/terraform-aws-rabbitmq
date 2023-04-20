variable "rabbitmq_name" {
  type        = string
  description = " (Required) Name of the broker."
}

variable "engine_type" {
  type        = string
  description = "(optional) Type of broker engine."
  default     = "RabbitMQ"
}

variable "engine_version" {
  type        = string
  description = "The version of the broker engine. See https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/broker-engine.html for more details"
  default     = "5.15.14"
}

variable "host_instance_type" {
  type        = string
  description = "The broker's instance type. e.g. mq.t2.micro or mq.m4.large"
  default     = "mq.t3.micro"
}

variable "deployment_mode" {
  type    = string
  description = "(Optional) Deployment mode of the broker. Valid values are `SINGLE_INSTANCE`, `ACTIVE_STANDBY_MULTI_AZ`, and `CLUSTER_MULTI_AZ`"
  default = "SINGLE_INSTANCE"
}

variable "auto_minor_version_upgrade" {
  type        = bool
  description = "Enables automatic upgrades to new minor versions for brokers, as Apache releases the versions"
  default     = false
}

variable "publicly_accessible" {
  type        = bool
  description = "Whether to enable connections from applications outside of the VPC that hosts the broker's subnets"
  default     = false
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of VPC subnet IDs"
}

variable "encryption_enabled" {
  type        = bool
  description = "Flag to enable/disable Amazon MQ encryption at rest"
  default     = true
}

variable "kms_mq_key_arn" {
  type        = string
  description = "ARN of the AWS KMS key used for Amazon MQ encryption"
  default     = null
}

variable "use_aws_owned_key" {
  type        = bool
  description = "Boolean to enable an AWS owned Key Management Service (KMS) Customer Master Key (CMK) for Amazon MQ encryption that is not in your account"
  default     = true
}

variable "tags" {
  description = "A mapping of tags to assign to security group"
  type        = map(string)
  default     = {}
}

variable "mq_application_user" {
  type        = list(string)
  description = "Application username"
  default     = []
}

variable "mq_application_password" {
  type        = list(string)
  description = "Application password"
  default     = []
  sensitive   = true
}

variable "enable_cloudwatch_logs" {
  type    = bool
  default = true
}

variable "maintenance_window_start_time" {
  type = object({
    mw_day_of_week = string
    mw_time_of_day = string
    mw_time_zone   = string
  })
  default = {
    mw_day_of_week = "SUNDAY"
    mw_time_of_day = "03:00"
    mw_time_zone   = "UTC"
  }
}