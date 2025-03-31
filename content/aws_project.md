+++
title = "Cloud Infrastructure Project – AWS Scalable Architecture"
date = 2024-05-30
draft = false
description = "A detailed showcase of a cloud-native application migration to AWS."
categories = ["Cloud Computing", "AWS", "Networking", "System Administration"]
tags = ["AWS", "Architecture", "Cloud"]
authors = ["Abdulla Bagishev"]
image = "/images/aws_project/aws.png"
avatar = "/images/AE.svg"
+++

# AWS Cloud Infrastructure Project
**Author**: Abdullah Bagishev  
**Year**: 2024  
**Subject: AWS Scalable Architecture**  


---

# **Migrating a Monolithic Application to a Cloud-Native AWS Architecture**  

## **Introduction**  
This project was part of a **Cybersecurity & Cloud academic assignment**, where the goal was to **modernize a legacy application** for **ACME Corp**. The existing **on-premises infrastructure** struggled with **scalability, cost-efficiency, and reliability**, making it unsuitable for growing demands.  

The solution? **Migrating to AWS** using a **highly available, auto-scaled, and cost-effective architecture**.  

---

## **Existing Issues (As-Is Situation)**  
The application currently **handles images and videos** through a **monolithic design**, running on a **single server**. This creates multiple problems:  

🔴 **Limited Scalability** – The server **cannot handle traffic spikes** (peaks: 9 AM - 5 PM).  
🔴 **Manual Resource Management** – No auto-scaling, leading to **waste** during low traffic.  
🔴 **Single Point of Failure** – A crash **takes down the entire service**.  
🔴 **High Maintenance Costs** – The existing **on-premises infrastructure** is expensive to maintain.  

### **Current Workload (Daily Averages)**  
📷 **1M image requests**, mainly **cached** (compressed to ~500KB).  
🎥 **10K video streams**, reducing size to **10% of original**.  
📂 **1000 image uploads (5MB each)** and **100 video uploads (500MB each)**.  

### **Goal: Migrate to a Cloud-Native Architecture**  
✅ **Auto-scale resources** based on real-time demand.  
✅ **Reduce operational costs** by leveraging **pay-as-you-go AWS pricing**.  
✅ **Ensure high availability** through redundancy and multi-AZ deployments.  
✅ **Decouple services** for better performance and fault tolerance.  

---

## **Target Architecture (To-Be Situation)**  

To achieve these goals, the application was **migrated to AWS** with the following key components:  

### **🖥 Compute & Load Balancing**  
- **Amazon EC2 (t3.medium)** → Runs application containers in a scalable, secure environment.  
- **Auto Scaling Group (ASG)** → Dynamically scales EC2 instances based on CPU load (>70%).  
- **Application Load Balancer (ALB)** → Distributes incoming traffic **evenly** across instances.  

### **🗄️ Storage & Database**  
- **Amazon S3** → Stores and serves uploaded images and videos.  
- **Amazon RDS (PostgreSQL, Multi-AZ)** → Manages **metadata storage** with built-in redundancy.  

### **🔗 Messaging & Queueing**  
- **Amazon SQS** → Handles **asynchronous task processing**, ensuring scalability and decoupling.  

### **🌐 Networking & Security**  
- **VPC (172.31.0.0/16)** → **Isolated cloud environment** with private and public subnets.  
- **NAT Gateway** → Enables **outbound internet access** for private instances.  
- **Security Groups & IAM Roles** → Implements strict **least-privilege access control**.  

---

## **Implementation Details**  

### **1️⃣ VPC & Network Setup**  
The AWS environment was configured using **a secure VPC architecture**:  
- **Public Subnets** → Hosts **ALB & NAT Gateway** for internet access.  
- **Private Subnets** → Houses **Auto Scaling EC2 instances & RDS PostgreSQL**.  
- **Security Groups & IAM Policies** → Define fine-grained **access control rules**.  

### **2️⃣ Compute & Scaling Strategy**  
- **Dockerized applications** deployed on **EC2 instances** (t3.medium).  
- **Auto Scaling Group** manages instances dynamically:  
  - **Min: 2 | Max: 4** instances (scaling up/down based on demand).  
  - **Scaling trigger:** CPU utilization **exceeds 70%**.  

### **3️⃣ Storage & Data Flow**  
- **User uploads** → Stored in **Amazon S3**.  
- **SQS handles message processing** → EC2 instances process images/videos asynchronously.  
- **Processed media** is stored back in **S3**, while **metadata is logged in RDS PostgreSQL**.  

---

## **Network Architecture & Security**  
This design follows **AWS best practices** to ensure **high availability, security, and efficient traffic flow**.

### **🔹 Breakdown of Network Design**
1️⃣ **VPC (Virtual Private Cloud)** → `172.31.0.0/16` for network isolation.  
2️⃣ **Public Subnets** → ALB & NAT Gateway for external access.  
3️⃣ **Private Subnets** → Secured EC2 instances & RDS database.  
4️⃣ **ALB (Application Load Balancer)** → Handles incoming traffic **securely**.  
5️⃣ **NAT Gateway** → Ensures private resources can **access the internet safely**.  
6️⃣ **Multi-AZ RDS PostgreSQL** → Ensures **high availability & disaster recovery**.  

### **🔹 Security Best Practices**
✅ **IAM Roles** → **Restricts access** to AWS services following the **principle of least privilege**.  
✅ **Security Groups** → Enforces strict inbound/outbound **traffic filtering**.  
✅ **Multi-AZ Deployment** → EC2, NAT Gateway, and RDS are **redundantly distributed** across AWS Availability Zones.  

---

## **Estimated Cost Breakdown (Per Month)**  

| **AWS Service** | **Cost Estimate** |
|----------------|------------------|
| EC2 Instances (Auto Scaling) | $79.88 |
| S3 Storage (75.15 TB) | $1,778.55 |
| RDS PostgreSQL (Multi-AZ) | $35.24 |
| SQS (Message Processing) | $0.40 |
| NAT Gateway (15TB Data Transfer) | $675.00 |
| Load Balancer (ALB) | $45.00 |
| **Total Monthly Cost** | **$2,557.57** |

---

## **Optimization Strategies**  
To further **reduce costs**, several improvements can be made:  
✅ **Switch NAT Gateway → AWS PrivateLink** → Cuts **outbound data transfer costs**.  
✅ **Enable S3 Intelligent-Tiering** → Moves infrequent data to **cheaper storage classes**.  

---

## **Results & Key Takeaways**  
🚀 **Scalability** → Auto Scaling ensures the application **handles peak loads seamlessly**.  
💰 **Cost Savings** → Migration from **fixed-cost on-premises to AWS pay-as-you-go pricing**.  
🔒 **Security & Compliance** → IAM, Security Groups, and VPC segmentation **ensure a secure environment**.  
💾 **Reliability & Resilience** → Multi-AZ RDS, ALB, and redundant EC2 instances **prevent downtime**.  

This migration successfully transformed **ACME Corp’s legacy application** into a **cloud-native, scalable, and cost-efficient solution**—making it future-proof for growth.  

