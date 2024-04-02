# 🏠 SmartHome 
Project's description.

## Getting Started
**AWS Account and Credentials**
- Create an [AWS Account](https://aws.amazon.com/)
- Install [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- Create an [AWS IAM User](https://docs.aws.amazon.com/IAM/latest/UserGuide/getting-started_create-admin-group.html) with Admin or Power User Permissions
  - this user will only be used locally
- [Configure the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) with the IAM User from the previous step.
  - Terraform will read your credentials via the AWS CLI 
  - [Other Authentication Methods with AWS and Terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication)

**Terraform**
- Install [HashiCorp Terraform](https://www.terraform.io/downloads)
- Install [Node.js](https://nodejs.org/en/)

## Structure: Modules
This section provides an overview of the modules included in this Terraform configuration and their functionality.


### **Networking**
This module creates a Virtual Private Cloud (VPC) with networking configurations to support the infrastructure's needs.
- **Fault-Tolerant**: The VPC spans across three availability zones to ensure high availability and fault tolerance.

- **Public and Private Subnets**: Public and Private subnets are provisioned in each availability zone, providing segregation of resources and enhancing security.

- **Internet Traffic Routing**: The VPC is configured to efficiently accept and route internet traffic, allowing the services to communicate with the outside world/the internet.

- **NAT Gateway**: A NAT Gateway is deployed to facilitate secure communication between Public and Private subnets. This enables bidirectional traffic routing, both internally within the VPC and to the internet.

## Usage
Before proceeding, ensure that you have authenticated your AWS account via the AWS CLI using your access keys.

To use these modules in your infrastructure, redirect yourself to the **terraform.tfvars** file located in the root directory and customize the values according to your specific requirements.


Here's an example:

```hcl
vpc_name             = "smart-home-microservices-vpc"
vpc_cidr_block       = "10.0.0.0/20"
enable_dns_hostnames = true

public_subnets = [{
  cidr_range              = "10.0.0.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true
  }, {
  cidr_range              = "10.0.1.0/24"
  availability_zone       = "eu-west-2b"
  map_public_ip_on_launch = true
  }, {
  cidr_range              = "10.0.2.0/24"
  availability_zone       = "eu-west-2c"
  map_public_ip_on_launch = true
}]

private_subnets = [{
  cidr_range        = "10.0.10.0/24"
  availability_zone = "eu-west-2a"
  }, {
  cidr_range        = "10.0.11.0/24"
  availability_zone = "eu-west-2b"
  }, {
  cidr_range        = "10.0.12.0/24"
  availability_zone = "eu-west-2c"
}]
```

After customizing the values, you can run Terraform commands: 
1. **terraform init** to initialize the project
2. **terraform plan** to generate an execution plan
3. And **terraform apply** to apply the changes to your infrastructure


