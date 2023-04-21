# variable "broker_cloudwatch_log_groups" {
#   type        = list(string)
#   default     = ["channel", "connection", "general"]
#   description = "List of Log Groups which will be created for the broker instance."
# }

# variable "cloudwatch_log_group_retention_in_days" {
#   type        = number
#   default     = 30
#   description = "The number of days to retain CloudWatch logs for the DB instance"
# }