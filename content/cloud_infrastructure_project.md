+++
title = "Cloud Infrastructure Project – VMware SDDC, vMotion, HA, FT, & MDM"
date = 2025-01-14
draft = false
description = "A detailed showcase of a virtualized cloud infrastructure using VMware technologies, including vMotion, High Availability (HA), Fault Tolerance (FT), and Mobile Device Management (MDM)."
categories = ["Cloud Computing", "Virtualization", "Networking", "System Administration"]
tags = ["VMware", "ESXi", "Azure AD"]
authors = ["Abdulla Bagishev"]
image = "/images/cloud_infrastructure_project/vmware.png"
avatar = "/images/AE.svg"
+++



# Cloud Infrastructure Project  
**Author**: Abdullah Bagishev  
**Year**: 2024 - 2025
**Subject: VMware SDDC, vMotion, HA, FT, & MDM**  

---

## Overview  
This project focuses on deploying a **highly available virtualized cloud environment** using **VMware SDDC technologies**. The setup ensures:  
✅ **Live VM Migration** (vMotion)  
✅ **High Availability (HA) & Continuous Availability (FT)**  
✅ **Centralized Storage with TrueNAS (iSCSI & Multipathing)**  
✅ **Automated Resource Management (DRS)**  
✅ **SSO & MDM (Microsoft Intune & Azure AD)**  

---

## **Architecture & Components**
### **Hypervisor & Compute**
- **VMware ESXi** (2 Hosts)
- **vCenter Server (VCSA)**
- **VMware Distributed Resource Scheduler (DRS)**
- **VMware High Availability (HA)**
- **VMware Fault Tolerance (FT)**

### **Storage & Networking**
- **TrueNAS** – iSCSI Shared Storage for vMotion & HA  
- **Multipathing for iSCSI** – Redundancy & Performance  
- **VMware Distributed Switch** – Ensures smooth migration  
- **IP Address Plan** 

### **Security & Authentication**
- **SSO with Active Directory (On-Premises)**
- **Azure AD & Microsoft Intune (MDM for Cloud SSO)**  
- **Security Groups & RBAC for VM Creators**  

---

## **Key Features & Configurations**
### **1. Live Migration with vMotion**
- **Tech Used:** VMware vMotion + Shared iSCSI Storage  
- **Purpose:** Migrate VMs **without downtime** during maintenance.  
- **Setup:**  
  - Enabled vMotion on both ESXi hosts.  
  - Connected ESXi hosts to **TrueNAS via iSCSI** for shared storage.  
  - Used **Distributed Switch** to ensure consistent networking.  
  - Verified with real-time VM migrations (**Click --> [Video Proof](https://youtu.be/yb3LMLyPjI0)**).  

### **2. High Availability (HA)**
- **Tech Used:** VMware HA Cluster  
- **Purpose:** Automatically restart VMs if an ESXi host fails.  
- **Setup:**  
  - Created an **HA Cluster in vCenter**.  
  - Configured **iSCSI Storage + Distributed Switch** to ensure failover.  
  - Simulated host failure (**Click --> [Test Results](https://youtu.be/wQGFyiqvU6A)**).  

### **3. Continuous Availability (FT - Fault Tolerance)**
- **Tech Used:** VMware FT  
- **Purpose:** **Zero-downtime failover** with a live copy of each VM.  
- **Setup:**  
  - Configured **Fault Tolerance on critical VMs**.  
  - Enabled **real-time state synchronization** between ESXi hosts.  
  - Verified **instant VM switchover** during host failure.  

### **4. Dynamic Resource Scaling with DRS**
- **Tech Used:** VMware Distributed Resource Scheduler (DRS)  
- **Purpose:** Automatically balance VM load across ESXi hosts.  
- **Setup:**  
  - Configured **Resource Pools** for different clients.  
  - Enabled **Auto-Migration of VMs** during high CPU/Memory usage.   

### **5. Role-Based Access for VM Creators**
- **Tech Used:** vCenter RBAC  
- **Purpose:** Restrict VM creation to specific users.  
- **Setup:**  
  - Created a **custom role "VM Creator"**.  
  - Assigned permissions for **only VM creation & modification**.  
  - Tested with limited-access users (**Click --> [Video Demo](https://youtu.be/SQXMv0oD-zQ)**).  

### **6. Hybrid SSO: On-Premises & Cloud**  
- **Tech Used:** Active Directory (LDAP) + Azure AD (Intune)  
- **Purpose:** Enable **Single Sign-On (SSO)** across Cloud & On-Premises.  
- **Setup:**  
  - Integrated **vCenter with Active Directory (LDAP)** to allow domain users to log in.  
  - Attempted **Azure AD Connect** for linking on-prem AD with Entra ID (Azure AD), but lacked the necessary administrative permissions. The **Entra ID environment was managed by my lecturer**, so I couldn’t complete the full cloud SSO configuration.  
  - Successfully verified **local SSO**, allowing domain users to authenticate in vCenter using their AD credentials.  


### **7. Mobile Device Management (MDM) with Intune**
- **Tech Used:** Microsoft Intune (Azure AD)  
- **Purpose:** Deploy & manage software across domain-joined devices.  
- **Setup:**  
  - Configured **MDM Policy** for Windows clients.  
  - **Auto-installed Audacity via Intune** (**Click for [Proof](https://youtu.be/XWmNyRJJ7nI)**).  
  - Forced domain login on Windows 11 clients (**cloud-ap.be**).  

---

## **IP Addressing Plan**
| Device            | IP Address   | Purpose                     |
|------------------|-------------|-----------------------------|
| **ESXi Host 1**   | 10.152.3.1   | Hypervisor Compute Node     |
| **ESXi Host 2**   | 10.152.3.2   | Hypervisor Compute Node     |
| **vCenter (VCSA)** | 10.152.3.3   | Centralized Management      |
| **TrueNAS (NIC1)** | 10.152.3.4   | Shared iSCSI Storage       |
| **TrueNAS (NIC2)** | 10.152.3.10  | Multipath iSCSI Redundancy |
| **DNS Server**    | 10.152.3.5   | AD & DNS Resolution        |
| **Distributed Switch NICs** | 10.152.3.8 - 10.152.3.9 | High-Speed Networking |

---

## **Video Demos**
📌 [vMotion Demonstration](https://youtu.be/yb3LMLyPjI0)  
📌 [High Availability in Action](https://youtu.be/wQGFyiqvU6A)  
📌 [Fault Tolerance Switchover](https://youtu.be/SQXMv0oD-zQ)  
📌 [MDM Auto-Install of Audacity](https://youtu.be/XWmNyRJJ7nI)  

---

![Fault Tolerance](/images/cloud_infrastructure_project/image.png)
**Note:** Here we can see that **VMware Fault Tolerance (FT)** is successfully enabled for the virtual machine **VM_ABD**. The **primary VM** is actively running, while the **secondary VM** is synchronized in real-time on a separate ESXi host. This ensures **continuous availability**—if the primary host fails, the secondary VM will take over **instantly with zero downtime**. 

![RDS](/images/cloud_infrastructure_project/image-1.png)
**Note:** Here we can see that **VMware Distributed Resource Scheduler (DRS)** is successfully configured within the **ResourcePool_Abdulla**. This setup ensures **automated resource management**, dynamically balancing CPU and memory workloads across the cluster. The **resource pool structure** allows for **segmentation of computing resources per client or workload**, ensuring guaranteed allocations and optimal performance. 

![MDM](/images/cloud_infrastructure_project/image-2.png)
**Note:** Here we can see the user successfully authenticated and applied the **MDM configuration policies** via **Microsoft Intune**. The device **U41-83** has been enrolled in **cloud-ap.be**, and both users (**u41user01 & u41user02**) have successfully passed the compliance checks. Additionally, the **default domain for Microsoft Entra Tenant** is correctly set to **cloud-ap.be**, ensuring seamless authentication and policy enforcement.