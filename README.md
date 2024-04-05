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
Creates a Virtual Private Cloud (VPC) with networking configurations to support the infrastructure's needs.
- **Fault-Tolerant**: The VPC spans across three availability zones to ensure high availability and fault tolerance.

- **Public and Private Subnets**: Public and Private subnets are provisioned in each availability zone, providing segregation of resources and enhancing security.

- **Internet Traffic Routing**: The VPC is configured to efficiently accept and route internet traffic, allowing the services to communicate with the outside world/the internet.

- **NAT Gateway**: A NAT Gateway is deployed to facilitate secure communication between Public and Private subnets. This enables bidirectional traffic routing, both internally within the VPC and to the internet.

### **Security**
Sets up a bastion host architecture for secure access to AWS EC2 instances.

In the context of this Terraform configuration, the [bastion host](https://aws.amazon.com/blogs/security/how-to-record-ssh-sessions-established-through-a-bastion-host/) is an EC2 instance that serves as a secure entry point into the network. It allows authorized users to SSH into it from their own IP addresses. Once authenticated, users can then SSH from the bastion host to other EC2 instances.

Why manually create a Bastion and not use Systems Manager Session Manager or EC2 Instance Connect? 
- When you manually set up an EC2 instance as a bastion host, you get to customize it exactly the way you want and it allows you to have total control over network settings and how resources are allocated, allowing you to fine-tune performance and manage costs very effectively.

This module consists of three security groups:

- **Bastion Host Security Group (bastion_sg)**:
Allows inbound SSH (port 22) traffic from specified IP addresses and permits outbound HTTP (port 80) and HTTPS (port 443) traffic to the internet.

- **Public Instances Security Group (public_sg)**:
Allows inbound SSH, HTTP, and HTTPS traffic from the bastion host's security group. It is designed for EC2 instances accessible from the internet.

- **Private Instances Security Group (private_sg)**:
Allows inbound SSH, HTTP, and HTTPS traffic from the bastion host's security group. It is intended for EC2 instances not directly accessible from the internet.

### **Databases**
Creates two DynamoDB tables, specifically designed for managing data related to lighting and heating systems.

Table(s) Configuration:
- Billing Mode: The tables are configured with the "PAY_PER_REQUEST" billing mode, allowing for flexible and cost-efficient scalability.
- Hash Key: Each table uses the "id" attribute as the hash key.
- Attribute Type: The "id" attribute is configured as a numeric attribute ("N") for optimal storage and query performance.


#### **Usage: Create an IAM USER**
We need to create an **IAM user** for these future services (lighting, heating) to interact with the databases so that they can authenticate the requests.

Use the IAM service on the AWS console to create a user that;

- Has policies which allow full access to DynamoDB
- Once created, give this user CLI access and save your keys somewhere as we will need to inject them later on into some of the services.

### **App-servers**
This module sets up five EC2 servers for each service, including a bastion host. They all have their specific and adequate security groups and subnets ids depending on their privacy settings.

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


