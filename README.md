# AWS Infrastructure as Code (IaC) for Network Deployment

This README provides instructions for deploying a network infrastructure on AWS using Infrastructure as Code (IaC). The setup includes the creation of a VPC, public and private subnets, and related resources. The deployment uses tools like Terraform, AWS CloudFormation, or CDK. This example assumes ***Terraform***.

### Prerequisites
$1.$ AWS CLI: Install and configure the AWS CLI with appropriate credentials.\
[Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

$2.$ AWS CLI: Install and configure the AWS CLI with appropriate credentials.Terraform: Install Terraform.\
[Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

$3.$ IAM Role/Permissions: Ensure your AWS credentials have sufficient permissions to create VPC, subnets, and related resources.

### Features
The IaC setup deploys:

- A VPC with a custom CIDR block.
- One public subnet and one private subnet.
- An Internet Gateway (IGW) for public subnet access.
- A NAT Gateway for private subnet internet access.
- Routing tables to manage traffic for public and private subnets.

#
### Architecture Diagram
```plaintext
VPC (10.0.0.0/16)
├── Public Subnet (10.0.1.0/24)
│   ├── Route Table → IGW (Internet Gateway)
├── Private Subnet (10.0.2.0/24)
    ├── Route Table → NAT Gateway
```
#

### File Structure

```plaintext
.
├── main.tf                # Core Terraform configuration
├── vars.tf                # Input variables for reusability
├── backend.tf             # Outputs for VPC, subnets, etc.
│   ├── terraform-aws-vpc  # Classless Inter-Domain Routing
│        ├── var.tf        # VPC CIDR variables
│        ├── vpc.tf        # VPC structure
└── README.md        # Project documentation
```

#

### Usage
#### Step 1: Clone the repository
```hcl
git clone https://github.com/csbasic/aws-network-infra.git
cd aws-network-infra
```

#### Step 2: Update Variables
Modify the terraform.tfvars file to customize the configuration. 

```bash
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidr  = "10.0.1.0/24"
private_subnet_cidr = "10.0.4.0/24"
```

#### Step 3: Initialize Terraform
Run the following command to initialize the Terraform working directory:

```bash
terraform init
```

#### Step 5: Plan the Deployment
Generate an execution plan to verify the resources to be created:

```bash
terraform plan
```

#### Step 5: Apply the Deployment
Deploy the infrastructure:

```bash
terraform apply
```

#### Step 6: Verify the Resources
Once applied, verify the output values for resource IDs and details:

```bash
terraform output
```

#

### Outputs
The following outputs will be provided upon successful deployment:

- VPC ID
- Public Subnet ID
- Private Subnet ID
- Internet Gateway ID
- NAT Gateway ID

#

### Cleanup
To destroy all resources created by this Terraform configuration, run:

```bash
terraform destroy
```

# 

### Additional Notes
- Ensure your IAM role has sufficient permissions (e.g., AmazonVPCFullAccess) to create networking resources.
- Update the security group rules in the configuration for specific traffic requirements.