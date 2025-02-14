+++
title = "Cloud Infrastructure Project – AWS Scalable Architecture"
date = 2024-05-30
draft = false
description = "A detailed showcase of a cloud-native application migration to AWS, leveraging EC2, S3, RDS, SQS, Auto Scaling, and Load Balancing for scalability, cost-efficiency, and high availability."
categories = ["Cloud Computing", "AWS", "Networking", "System Administration"]
tags = ["AWS", "EC2", "S3", "RDS", "SQS", "Auto Scaling", "Load Balancer"]
authors = ["Abdulla Bagishev"]
image = "/images/aws_project/aws.png"
avatar = "/images/AE.svg"
+++

# AWS Cloud Infrastructure Project
**Author**: Abdullah Bagishev  
**Year**: 2024  
**Subject: AWS Scalable Architecture**  


---

## Overview  
This project focuses on **migrating a traditional application** to a **cloud-native architecture on AWS** to improve **scalability, cost efficiency, and reliability**. The architecture leverages AWS services such as **EC2, S3, RDS, SQS, Auto Scaling, and Load Balancing** to optimize performance and handle high traffic loads.

---

## **Architecture & Components**

### **Compute & Hosting**
- **EC2 Instances (t3.medium)** – Web server and task processing instances.
- **Auto Scaling Group (ASG)** – Dynamically scales EC2 instances based on load.
- **Application Load Balancer (ALB)** – Distributes traffic across EC2 instances.

### **Storage & Data Management**
- **Amazon S3** – Stores uploaded images and videos.
- **Amazon RDS (PostgreSQL, Multi-AZ)** – Manages metadata storage with high availability.

### **Messaging & Queueing**
- **Amazon SQS** – Handles message processing between application components.

### **Networking & Security**
- **VPC with Public & Private Subnets** – Securely isolates instances and data.
- **NAT Gateway** – Provides internet access for private instances.
- **Security Groups & IAM Roles** – Manages access control.

---

## **Current vs. Future State**

### **As-Is Situation (Before Cloud Migration)**
- A **monolithic** application handling images and videos.
- **On-premises hosting** with limited scalability.
- **Manual resource allocation**, causing inefficiencies.
- **No fault tolerance** – risk of downtime during failures.

### **To-Be Situation (After Cloud Migration)**
- **Cloud-native architecture** with autoscaling and redundancy.
- **AWS-managed services** replacing manual infrastructure.
- **Seamless scaling** to handle peak loads efficiently.
- **Cost-efficient operations** with pay-as-you-go pricing.

---

## **Implementation Details**

### **1. VPC Configuration**
- **CIDR:** `172.31.0.0/16`
- **Public Subnets:** Internet access via ALB & NAT Gateway.
- **Private Subnets:** Secure backend and database instances.

### **2. EC2 & Auto Scaling**
- **t3.medium instances** running Dockerized web servers.
- **Min instances: 2 | Max instances: 4**.
- Auto-scaling **triggers when CPU > 70%**.

### **3. Storage & Data Processing**
- **Uploads go to Amazon S3**.
- **SQS queues process image transformations**.
- **Processed images/videos stored back in S3**.
- **Metadata stored in RDS PostgreSQL (Multi-AZ)**.

---

## **Network Architecture & Security**
This architecture follows **AWS best practices** to ensure **high availability, security, and efficient traffic flow**. Below is the network schema:

![AWS Network Architecture](/images/aws_project/image.png)
### **🔹 Breakdown of the Network Design**

#### **1. VPC (Virtual Private Cloud) – `172.31.0.0/16`**
- Provides an **isolated network environment** for the cloud infrastructure.

#### **2️. Public Subnets – `172.31.16.0/20` & `172.31.32.0/20`**
- Contain **NAT Gateway & Application Load Balancer (ALB)**.
- The **ALB** routes incoming traffic to the private application servers.

#### **3️. Private Subnets – `172.31.100.0/24` & `172.31.101.0/24`**
- Host **Auto Scaling EC2 Instances** (Web/App servers).
- No direct internet access; secured behind NAT Gateway.

#### **4️. Application Load Balancer (ALB)**
- Distributes incoming HTTP/HTTPS traffic **evenly** across EC2 instances in the **Auto Scaling Group**.
- **Public-facing**, but only allows **inbound traffic on ports 80/443**.

#### **5️. Auto Scaling Group (ASG) – Private Subnet**
- Ensures **scalability** by automatically adjusting the number of EC2 instances.
- Connects **only** to the ALB (not publicly exposed).

#### **6️. NAT Gateway**
- Allows **outbound internet access** for private EC2 instances **without exposing them**.
- Used for downloading software updates, S3 communication, etc.

#### **7️. Amazon RDS (PostgreSQL) – Private Subnet**
- Database is **isolated** with **no public IP**.
- Only accessible by **EC2 instances** in the private subnet.

### **🔹 Security Measures Implemented**
**Security Groups (SGs) & IAM Roles**
- **ALB Security Group:** Allows **HTTP/HTTPS (80/443) inbound**.
- **EC2 Security Group:** Only allows **internal traffic from ALB & NAT Gateway**.
- **RDS Security Group:** Only allows **connections from EC2 instances**.
- **IAM Roles:** Restrict access to S3, SQS, and other AWS services **based on least privilege**.

**Multi-AZ Deployment for High Availability**
- EC2 instances, NAT Gateway, and RDS **are deployed across multiple Availability Zones**.
- Ensures **automatic failover** in case of AZ failure.

**Private Subnet for Secure Database & App Layer**
- Prevents **direct access to application & database** from the internet.
- Only the **ALB and NAT Gateway** can communicate with the outside world.

---

## **Cost Estimation (Per Month)**
| **Service**    | **Cost** |
|--------------|---------|
| EC2 Instances (t3.medium, Auto Scaling) | $79.88 |
| S3 Storage (75.15 TB) | $1,778.55 |
| RDS PostgreSQL (db.t3.micro, Multi-AZ) | $35.24 |
| SQS Message Processing | $0.40 |
| NAT Gateway (15TB Data Transfer) | $675.00 |
| Load Balancer (ALB, LCU Costs) | $45.00 |
| **Total Monthly Cost** | **$2,557.57** |

---

## **Potential Optimizations**
✅ **Switching from NAT Gateway to AWS PrivateLink** → Reduces data transfer costs.  
✅ **Using Spot Instances for EC2** → Lower costs by leveraging unused AWS capacity.  
✅ **Enabling S3 Intelligent-Tiering** → Reduces storage costs by auto-tiering infrequently accessed data.  

---

