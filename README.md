# terraform-aws-rabbitmq
We are publishing our module to [**RabbitMQ AWS Terraform**](https://registry.terraform.io/modules/mrnim94/rabbitmq/aws/latest)

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

## Create RabbitMQ Cluster

### Get VPC and Subnets from the remote tfstate

```hcl
# output "vpc_id" {
#   value = data.aws_vpc.selected.id
# }

# output "subnet_id" {
#   value = data.aws_subnet.selected.id
# }

data terraform_remote_state "network" {
    backend = "s3"
    config = {
        bucket = "private-windows-mdaas-eks-tf-lock"
        key = "network.tfstate"
        region = "us-east-1"
     }
}

module "rabbitmq" {
  source  = "github.com/mrnim94/terraform-aws-rabbitmq?ref=master"
  # insert the 2 required variables here
  rabbitmq_name = "rabbitmq-${var.business_divsion}-${var.environment}"
  engine_version = "3.8.6"
  deployment_mode = "CLUSTER_MULTI_AZ"
  subnet_ids = data.terraform_remote_state.network.outputs.private_subnets
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id
  create_security_group = "true"
  publicly_accessible = "false"
  host_instance_type = "mq.m5.large"
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

### Get VPC and Subnets from data sources

```hcl

data "aws_vpc" "selected" {
  tags = {
    Name = "dev-mdcl-mdaas-engine" # Replace with your VPC's tag name
  }
}


# output "vpc_id" {
#   value = data.aws_vpc.selected.id
# }

data "aws_subnets" "private_networks" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "tag:kubernetes.io/role/internal-elb"
    values = ["1"]
  }
}

# output "subnet_ids" {
#   value = data.aws_subnets.example.ids
# }

module "rabbitmq" {
  source  = "mrnim94/rabbitmq/aws"
  version = "0.1.1"
  # insert the 2 required variables here
  rabbitmq_name         = "rabbitmq-${var.business_divsion}-${var.environment}-19-02-2024"
  engine_version        = "3.10.20"
  deployment_mode       = "CLUSTER_MULTI_AZ"
  subnet_ids            = data.aws_subnets.private_networks.ids
  vpc_id                = data.aws_vpc.selected.id
  host_instance_type = "mq.m5.large"
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

Pay attention to: Deployment mode **[CLUSTER_MULTI_AZ]** is not available on instance type **[MQ_T3_MICRO]**

## How to Get Password of RabbitMQ(AmazonMQ)   
You can get username and password in `terraform.tfstate` file


[![Image](https://nimtechnology.com/wp-content/uploads/2023/04/image-96.png "[RabbitMQ/AWS] Install RabbitMQ on AWS based on Amazon MQ. ")](https://nimtechnology.com/2023/04/22/rabbitmq-aws-install-rabbitmq-on-aws-based-on-amazon-mq/)
