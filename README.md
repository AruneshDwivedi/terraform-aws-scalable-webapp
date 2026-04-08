# 🚀 Terraform AWS Scalable Web App Infrastructure

## 📌 Overview

This project demonstrates a **production-style AWS infrastructure** built using **Terraform (Infrastructure as Code)**.

It provisions a **highly available and scalable architecture** using:

* VPC with public & private subnets
* Internet Gateway + NAT Gateway
* Application Load Balancer (ALB)
* Auto Scaling Group (EC2 in private subnet)
* RDS (MySQL)
* Secure Security Group configuration

---

## 🏗️ Architecture

User → ALB (Public Subnet) → EC2 (Private Subnet) → RDS (Private Subnet)

---

## 📸 Screenshots

### ❌ Initial Issue – 504 Gateway Timeout

<img width="3840" height="1080" alt="Screenshot (427)" src="https://github.com/user-attachments/assets/6395b46c-f3d7-4277-b37f-bcbfc8e512cf" />


---

### ✅ Application Working Successfully

<img width="1920" height="1080" alt="Screenshot (428)" src="https://github.com/user-attachments/assets/c330aa78-7dd8-4992-8457-35319f11ca81" />

---

### ✅ Healthy Target Group


<img width="1920" height="1080" alt="Screenshot (429)" src="https://github.com/user-attachments/assets/e62ab2e8-37a7-411d-96cb-150cc004027b" />

---

## ⚙️ Tech Stack

* Terraform
* AWS (VPC, EC2, ALB, ASG, RDS)
* Linux (Amazon Linux)
* Apache (httpd)

---

## 📁 Project Structure

```
terraform-aws-scalable-webapp/
│
├── environments/
│   └── dev/
│       └── main.tf
│
├── modules/
│   ├── vpc/
│   ├── alb/
│   ├── compute/
│   └── rds/
│
├── images/
└── README.md
```

---

## 🚀 How to Run

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

Get ALB URL:

```bash
terraform state show module.alb.aws_lb.app | grep dns_name
```

Open in browser:

```
http://<ALB-DNS>
```

---

## ⚠️ Challenges Faced & Fixes

### ❌ 504 Gateway Timeout

**Cause:**

* EC2 instances were not responding to ALB health checks

**Fix:**

* Corrected user_data script
* Ensured Apache installed & running
* Added retry logic for package installation

---

### ❌ No Internet in Private Subnet

**Cause:**

* EC2 instances couldn’t install packages

**Fix:**

* Configured NAT Gateway properly
* Fixed private route table

---

### ❌ Security Group Misconfiguration

**Cause:**

* ALB couldn’t communicate with EC2

**Fix:**

```hcl
cidr_blocks = ["10.0.0.0/16"]
```

---

### ❌ Invalid AMI

**Cause:**

* AMI not available in region

**Fix:**

* Used correct AMI for us-east-1

---

## 💡 Key Learnings

* Debugging cloud infra is more important than writing code
* Networking (VPC, NAT, SG) is critical
* ALB health checks determine system availability
* Private subnet architecture requires NAT for outbound traffic

---

## 🎯 Result

* Fully working scalable web app
* Load balanced traffic via ALB
* Auto scaling enabled
* Application accessible publicly

---

## 🧹 Cleanup (IMPORTANT)

```bash
terraform destroy
```

---

## 🚀 Future Improvements

* HTTPS (ACM + HTTPS listener)
* Remote backend (S3 + DynamoDB)
* CI/CD pipeline (GitHub Actions / Jenkins)
* Docker + ECS/EKS

---

## 👨‍💻 Author

Arunesh Dwivedi
