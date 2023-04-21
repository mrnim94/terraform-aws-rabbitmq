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
  
  dynamic "encryption_options" {
    for_each = var.encryption_enabled ? ["true"] : []
    content {
      kms_key_id        = var.kms_mq_key_arn
      use_aws_owned_key = var.use_aws_owned_key
    }
  }

  security_groups = local.broker_security_groups

  logs {
    general = var.enable_cloudwatch_logs
    audit   = false
  }

  maintenance_window_start_time {
    day_of_week = var.maintenance_window_start_time.mw_day_of_week
    time_of_day = var.maintenance_window_start_time.mw_time_of_day
    time_zone   = var.maintenance_window_start_time.mw_time_zone
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