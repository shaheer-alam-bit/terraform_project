# Scalable, Secure, and Containerized AWS Environment Using Terraform

This repository contains Terraform code and Dockerfiles to provision a scalable, secure, and containerized AWS infrastructure. The solution includes Auto Scaling EC2 instances, RDS databases, a Load Balancer with HTTPS support, Dockerized applications, and a deployed Business Intelligence (BI) tool.

---

## Features

### 1. **Auto Scaling EC2 Instances**

* Configured to launch and scale EC2 instances with:

  * **Nginx**
  * **Docker**
  * **Node.js 20**
* EC2 instances utilize User Data scripts for initialization.

### 2. **RDS Databases**

* MySQL and PostgreSQL databases deployed in **private subnets** for security.
* Accessible securely via **SSH tunnels**.

### 3. **Application Load Balancer (ALB)**

* Handles HTTP and HTTPS traffic.
* Configured with:

  * Domain integration
  * AWS ACM SSL certificates for HTTPS encryption.

### 4. **Dockerized Applications**

* Supports multi-stage Dockerfiles for the **Frontend** and **Backend** applications.
* Applications are hosted on EC2 instances and exposed via the ALB.

### 5. **Business Intelligence Tool**

* Deploys **Redash** or **Metabase** using Docker.
* Integrated with RDS databases for real-time dashboarding and analytics.

### 6. **Domain and SSL Setup**

* Custom domain support with Route 53.
* Enforces HTTPS using SSL certificates provided by AWS ACM.

---

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/shaheer-alam-bit/terraform_project.git
cd terraform_project
```

### 2. Initialize Terraform

Navigate to the Terraform directory:

```bash
cd terraform
terraform init
```

### 3. Deploy Infrastructure

Run the following command to deploy the infrastructure:

```bash
terraform apply
```

### 4. Secure Database Access

To access the RDS instances securely, set up an **SSH tunnel**:

```bash
ssh -i <PRIVATE_KEY>.pem ec2-user@<EC2_PUBLIC_IP> -L 3306:<MySQL_Endpoint>:3306
```

---
