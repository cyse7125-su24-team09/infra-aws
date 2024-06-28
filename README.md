# infra-aws

This repository contains the infrastructure setup for the AWS EKS cluster, VPC, and related infrastructure components required. It will bootstrap the deployment of Kubernetes resources and Helm releases on the AWS EKS cluster.


## Architecture

The architecture of this project includes:

- **Amazon EKS**: Managed Kubernetes service for running Kubernetes clusters.
- **VPC**: Virtual Private Cloud to isolate the EKS cluster.
- **Subnets**: Public and private subnets for network segmentation.
- **Internet Gateway**: For enabling internet access to the VPC.
- **NAT Gateway**: For enabling internet access for instances in private subnets.
- **Security Groups**: To control inbound and outbound traffic to resources in the VPC.
- **Kubernetes Resources**: To bootstrap creation of kubernetes resources on the EKS cluster.
- **Helm Releases**: To bootstrap deployment of helm charts on the EKS cluster.

## Prerequisites

Before you begin, ensure you have the following:

- An AWS account with the necessary permissions.
- Set an AWS Profile
- AWS CLI installed and configured.
- Terraform installed (if using Terraform for IaC).
- Kubectl installed for managing Kubernetes clusters.

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/cyse7125-su24-team09/infra-aws.git
cd infra-aws
```

### 2. Configure AWS CLI

Ensure your AWS CLI is configured with the necessary credentials and region settings.

```bash
aws configure
```

### 3. Provision Infrastructure

Use Terraform to provision the infrastructure. Navigate to the Terraform directory and initialize Terraform.

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

## Configuration

The configuration files for the VPC, EKS cluster, and other components are located in the `terraform` directory. Modify these files as needed to fit your specific requirements. To configure values for kafka and postgres helm charts, refer to the example.values.yaml file present in the respective helm modules. Configure the path to the values.yaml file using variables `helm_postgres_release_config.values_file_path` and `helm_kafka_release_config.values_file_path` defined in tfvars.

## Usage

Once the infrastructure is set up, you can deploy your applications to the EKS cluster using kubectl or helm releases.

## Cleanup

To tear down the infrastructure, use Terraform to destroy the resources.

```bash
terraform destroy
```

### 4. Configure Kubectl

Update your kubeconfig to point to the new EKS cluster.

```bash
aws eks update-kubeconfig --name <cluster-name> --region <aws-region> --profile <aws-profile-name>
```

