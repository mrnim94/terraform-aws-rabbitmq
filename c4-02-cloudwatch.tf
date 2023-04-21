resource "aws_cloudwatch_log_group" "this" {
  for_each = var.enable_cloudwatch_logs ? toset(var.broker_cloudwatch_log_groups) : []

  name              = "/aws/amazonmq/broker/${aws_mq_broker.rabbitmq.id}/${each.key}"
  retention_in_days = var.cloudwatch_log_group_retention_in_days

  tags = var.tags
}