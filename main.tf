locals {
  broker_security_groups = var.create_security_group ? [module.security_group[0].security_group_id] : var.security_groups

  mq_application_user_needed = length(var.mq_application_user) == 0
  mq_application_user        = local.mq_application_user_needed ? random_pet.mq_application_user[0].id : try(var.mq_application_user[0], "")

  mq_application_password_needed = length(var.mq_application_password) == 0
  mq_application_password        = local.mq_application_password_needed ? random_password.mq_application_password[0].result : try(var.mq_application_password[0], "")
}

resource "random_pet" "mq_application_user" {
  count     = local.mq_application_user_needed ? 1 : 0
  length    = 2
  separator = "-"
}

resource "random_password" "mq_application_password" {
  count   = local.mq_application_password_needed ? 1 : 0
  length  = 24
  special = false
}

resource "aws_mq_configuration" "rabbitmq" {
  name           = "${var.rabbitmq_name}-config"
  engine_type    = var.engine_type
  engine_version = var.engine_version

  data = <<EOT
# By default the delivery acknowledgement timeout is infinite in RabbitMQ versions prior to 3.8.15
# If you upgrade your broker to a more recent version, the default timeout will be 30 minutes
consumer_timeout = 1800000
max-connections = 1000
EOT
}

resource "aws_mq_broker" "rabbitmq" {
  broker_name = var.rabbitmq_name
  engine_type = var.engine_type
  engine_version = var.engine_version

  # the most cheap type is mq.m5.large on multi az deployment mode, mq.t3.micro is available on SINGLE_INSTANCE deployment mode.
  host_instance_type = var.host_instance_type
  deployment_mode     = var.deployment_mode
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  publicly_accessible        = var.publicly_accessible
  subnet_ids                 = var.subnet_ids

  security_groups = local.broker_security_groups

  configuration {
    id       = aws_mq_configuration.rabbitmq.id
    revision = aws_mq_configuration.rabbitmq.latest_revision  
  }

  logs {
    general = var.enable_cloudwatch_logs
    audit   = false
  }

  dynamic "maintenance_window_start_time" {
    for_each = var.enable_maintenance_window ? [1] : []
    content {
      day_of_week = var.maintenance_window_start_time.mw_day_of_week
      time_of_day = var.maintenance_window_start_time.mw_time_of_day
      time_zone   = var.maintenance_window_start_time.mw_time_zone
    }
  }

  user {
    username = local.mq_application_user
    password = local.mq_application_password
  }

  tags = var.tags

  depends_on = [
    module.security_group
  ]
}