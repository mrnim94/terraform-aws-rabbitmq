# terraform-aws-rabbitmq

## You can install RabbitMQ on AWS easily.
I have refer 3 public modules:  
https://github.dev/dasmeta/terraform-aws-rabbitmq/blob/main/security-group.tf  
https://github.dev/vainkop/terraform-aws-rabbitmq/blob/master/main.tf  
https://github.dev/cloudposse/terraform-aws-mq-broker/blob/master/variables.tf  

### Single-node and Create Security Group
```hcl
provider "aws" {
  region     = var.aws_region
}
data "aws_vpc" "selected" {
  tags = {
    Name = "<value>" # Replace with your VPC's tag name
  }
}

data "aws_subnet" "selected" {
  vpc_id = data.aws_vpc.selected.id

  tags = {
    Name = "<value>" # Replace with your Subnet's tag name
  }
}

# output "vpc_id" {
#   value = data.aws_vpc.selected.id
# }

# output "subnet_id" {
#   value = data.aws_subnet.selected.id
# }

module "rabbitmq" {
  source  = "mrnim94/rabbitmq/aws"
  version = "0.0.12"
  # insert the 2 required variables here
  rabbitmq_name = "rabbitmq-${var.business_divsion}-${var.environment}"
  engine_version = "3.8.6"
  deployment_mode = "SINGLE_INSTANCE"
  subnet_ids = [data.aws_subnet.selected.id]
  vpc_id = data.aws_vpc.selected.id
  create_security_group = "true"
  ingress_with_cidr_blocks = [
    {
      from_port   = 5671
      to_port     = 5671
      protocol    = "tcp"
      description = "access to RabbitMQ"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "access to https"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "access to http"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}
```

## Create Public RabbitMQ  


```hcl
data "aws_vpc" "selected" {
  tags = {
    Name = "dev-mdcl-mdaas-engine" # Replace with your VPC's tag name
  }
}

data "aws_subnet" "selected" {
  vpc_id = data.aws_vpc.selected.id

  tags = {
    Name = "dev-mdcl-mdaas-engine-private-us-west-2b" # Replace with your Subnet's tag name
  }
}

# output "vpc_id" {
#   value = data.aws_vpc.selected.id
# }

# output "subnet_id" {
#   value = data.aws_subnet.selected.id
# }

module "rabbitmq" {
  source  = "mrnim94/rabbitmq/aws"
  version = "0.0.12"
  # insert the 2 required variables here
  rabbitmq_name = "rabbitmq-${var.business_divsion}-${var.environment}"
  engine_version = "3.8.6"
  deployment_mode = "SINGLE_INSTANCE"
  subnet_ids = [data.aws_subnet.selected.id]
  vpc_id = data.aws_vpc.selected.id
  publicly_accessible = "true"
}
```

## How to Get Password of RabbitMQ(AmazonMQ)   
You can get username and password in `terraform.tfstate` file


[![Image](https://nimtechnology.com/wp-content/uploads/2023/04/image-96.png "[RabbitMQ/AWS] Install RabbitMQ on AWS based on Amazon MQ. ")](https://nimtechnology.com/2023/04/22/rabbitmq-aws-install-rabbitmq-on-aws-based-on-amazon-mq/)
