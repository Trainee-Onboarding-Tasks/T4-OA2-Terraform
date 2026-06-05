# T4-OA2-Terraform


# Table of Contents
* [Overview](#overview)
* [Project Structure](#project-structure)
* [General Prerequires](#general-prerequires)
* [Setup & Run](#setup--run)
    * [Local Execution](#local-execution)
    * [GitHub Actions Execution](#github-actions-execution)

---



# Overview

This repository contains Infrastructure as Code (IaC) written in Terraform for deploying the infrastructure required to host an OAuth2 authentication and authorization server on AWS.

It provisions the core cloud resources needed to run the OAuth2 service, including networking, security, compute resources, and supporting infrastructure. 

### Separation of Responsibilities

To ensure clean and maintainable operations, the project enforces a strict separation of concerns between infrastructure provisioning and software configuration:

*   **Infrastructure Provisioning (Terraform):** Responsible for the lifecycle, orchestration, and wiring of all AWS cloud resources. It builds the network foundation (VPC, Subnets, Load Balancers) and spins up the virtual hardware (EC2 instances).
*   **Configuration Management (Ansible):** Responsible for OS hardening, dependency installation, and deploying the OAuth2 server software onto the provisioned instances.

### Environment Architecture

The environment is architected for security and automated management, split into distinct layers:
*   **Edge & Routing:** An Application Load Balancer acts as the single public entry point, handling SSL/TLS termination and shielding the backend instances.
*   **Application Layer:** The OAuth2 server runs on a dedicated EC2 instance inside the VPC, isolated from direct internet access and reachable only via the load balancer.
*   **Management & CI/CD Control Node:** A dedicated **Ansible Server** is deployed within the infrastructure. This server acts as an internal execution environment that pulls playbooks from the GitHub repository - https://github.com/Trainee-Onboarding-Tasks/T4-OA2-Ansible.git  and bridges GitHub Actions workflows with the AWS infrastructure to safely configure and deploy application updates.

All infrastructure is deployed automatically through GitHub Actions workflows, providing a consistent, auditable, and repeatable deployment process across environments.

---



# Project Structure

1. Networking (VPC module)

    Creates:

    - VPC (10.0.0.0/16 recommended)
    - Public subnets for external access
    - Internet Gateway for public connectivity


2. Security (SG module)

    Security groups control access to infrastructure components:

    - Load Balancer SG
        - HTTPS access (port 443) from the Internet
        - Forwards traffic to the OAuth2 server
    - OAuth2 Server SG
        - Accepts traffic only from the Load Balancer
        - SSH access can be restricted to allowed IPs if required

3. Compute (server module)
    - OAuth2 Server
        - EC2 instance hosting the OAuth2 service
        - Deployed inside the VPC
        - Handles authentication and authorization requests

    - Ansible server
        - EC2 instance with ansible for configuration management and deployment
        - Handles GitHub Actions CI/CD pipelines

4. Load Balancing (LB module)
    - Application Load Balancer
    - HTTPS listener (port 443)
    - SSL/TLS termination
    - Routes incoming requests to the OAuth2 server

---


# General Prerequires


### Terraform State S3 Bucket

The project uses an S3 bucket to store Terraform remote state:

- Default bucket name: `trainee-onboarding-tasks`

This bucket is not strictly required to exist beforehand:

- Create a new S3 bucket manually if needed
- Preferably create it in the same AWS region as the deployment
- Update the backend configuration in Terraform (`main.tf`) accordingly

This ensures Terraform state consistency across deployments.


### Domain Configuration (Route53)

A Route53 hosted zone is used to provide a custom domain for accessing the application:

- Domain: `trainee-keycloack.store`

The hosted zone must already exist in AWS Route53 before deployment.


### HTTPS / TLS Certificate (ACM)

An SSL/TLS certificate must be available in AWS Certificate Manager (ACM):

- Certificate must be issued and valid for: `trainee-keycloack.store`
- The certificate must include the tag:
    - `Name = "main-domain-certificate"`

Terraform uses this tag to automatically locate the correct certificate via a data source lookup.



### AWS Resource Configuration (Post-Deployment)

After infrastructure provisioning, additional AWS configuration is required.

#### Load Balancer Configuration
Go to EC2 -> Load Balancers
Locate the Application Load Balancer: `proxy-alb`
Copy its DNS name (or use it for Route53 alias configuration)


#### Route53 Record Setup

Go to Route53 -> Hosted Zones
Select hosted zone for: `trainee-keycloack.store`
Create or update an two A record with names `oauth2.trainee-keycloack.store`, `keycloak.trainee-keycloack.store`:

- Type: `A (Alias)`
- Alias: enabled
- Target: select Application Load Balancer `proxy-alb`

---


# Setup & Run

## Local Execution

1.  **Prerequisites**:
    *   AWS CLI installed and configured with creds
    *   HashiCorp Terraform is installed

2.  **Configuration**:
    In folder `iac/` in root file `variables.tf` configure variables:

    ```bash
    variable "aws_region" {
      type        = string
      description = "AWS region to deploy resources"
      default     = "us-east-1"
    }


    variable "proxy_server_instance_ami_id" {
      type        = string
      description = "AMI ID for proxy instance server"
      default     = "ami-0bff6c92510b45277"
    }


    variable "ansible_server_instance_ami_id" {
      type        = string
      description = "AMI ID for proxy instance server"
      default     = "ami-0dd23b7cbc421d704"
    }


    variable "proxy_server_instance_type" {
      type        = string
      description = "Proxy server instance type name"
      default     = "t3.medium"
    }


    variable "ansible_server_instance_type" {
      type        = string
      description = "Proxy server instance type name"
      default     = "t3.micro"
    }


    variable "alb_listener_http_port" {
      type        = number
      description = "ALB HTTP listener port"
      default     = 80
    }


    variable "alb_listener_https_port" {
      type        = number
      description = "ALB HTTPS listener port"
      default     = 443
    }


    variable "proxy_listener_port" {
      type        = number
      description = "Proxy server listener port"
      default     = 80
    }


    variable "https_certificate_arn" {
      type        = string
      description = "HTTPS certificate arn"
      default     = "arn:aws:acm:us-east-1:971778147356:certificate/90ce286a-fa70-4054-99f7-a201c1aed4b2"
    }

    ```
    there are special variables. 

    ##### (Important) Make sure that AMI for all servers are exists in your AWS account, if not there creation is described in following repository - https://github.com/Trainee-Onboarding-Tasks/T4-OA2-Packer.git

3.  **Build**:
    ```bash
    terraform init .
    terraform apply -var-file="env.tfvars" -auto-approve
    ```

## GitHub Actions Execution
The infrastructure deployment process is fully automated using GitHub Actions.


1. Configure AWS IAM Role

    Before running the workflow, ensure that an AWS IAM role exists and is configured for GitHub OIDC authentication.

    The role must:

    - Trust GitHub's OIDC provider
    - Allow GitHub Actions to assume the role
    - Have permissions required to manage the AWS resources provisioned by Terraform

2. Pull Request Validation

    When a Pull Request targeting the main branch contains changes in the `iac/` directory, GitHub Actions automatically performs:

    - Terraform initialization (`terraform init`)
    - Terraform configuration validation (`terraform validate`)
    - Terraform execution plan (`terraform plan`)

    This allows infrastructure changes to be reviewed before deployment.

3. Automatic Deployment

    When changes are merged into the main branch, GitHub Actions automatically:

    - Authenticates to AWS using OIDC
    - Initializes Terraform
    - Applies infrastructure changes

    Deployment is executed using:

    ```bash
    terraform apply -auto-approve
    ```

4. Workflow Triggers

    The workflow runs automatically when:

    A Pull Request modifies files inside the `iac/` directory
    Changes are pushed to the main branch affecting files inside the `iac/` directory


---
