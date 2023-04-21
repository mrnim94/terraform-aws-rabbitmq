# terraform-aws-rabbitmq

## You can install RabbitMQ on AWS easily.
I have refer 3 public modules:  
https://github.dev/dasmeta/terraform-aws-rabbitmq/blob/main/security-group.tf  
https://github.dev/vainkop/terraform-aws-rabbitmq/blob/master/main.tf  
https://github.dev/cloudposse/terraform-aws-mq-broker/blob/master/variables.tf  

### Single-node
```hcl
provider "aws" {
  region     = var.aws_region
}
module "rabbitmq" {
  source  = "mrnim94/rabbitmq/aws"
  version = "0.0.11"
  # insert the 2 required variables here
  rabbitmq_name = "nimtechnology-rabbitmq"
  engine_version = "3.8.6"
  deployment_mode = "SINGLE_INSTANCE"
  subnet_ids = ["subnet-0088935e564caec68"]
  vpc_id = "vpc-04c4898260c0eb6e2"
  create_security_group = "true"
  ingress_with_cidr_blocks = [
    {
      from_port   = 5671
      to_port     = 5671
      protocol    = "tcp"
      description = "access to RabbitMQ"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}
```

[![Image](https://nimtechnology.com/wp-content/uploads/2023/04/image-96.png "[RabbitMQ/AWS] Install RabbitMQ on AWS based on Amazon MQ. ")](https://nimtechnology.com/2023/04/22/rabbitmq-aws-install-rabbitmq-on-aws-based-on-amazon-mq/)