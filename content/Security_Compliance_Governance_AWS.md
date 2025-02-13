+++
title = "AWS Security, Compliance, and Governance - Study Notes"
date = 2025-02-13
description = "Persoonlijke studienotities over AWS Security, Compliance en Governance, gebaseerd op de AWS Certified Advanced Networking Study Guide (2e editie)."
categories = ["AWS", "Cloud Security", "Cybersecurity"]
authors = ["Abdulla Bagishev"]
image = "/images/Security_Compliance_Governance_images/AWS.png"
avatar = "/images/AE.svg"
slug = "aws-security-compliance-governance"
+++

# **Security, Compliance, and Governance**  
**Auteur: Abdulla Bagishev**  
**Jaar: 2025**  
**Onderwerp: AWS Security, Compliance en Governance**  

---

**Personal Note**
These are my personal notes as part of my self-study in AWS networking, based on the book AWS® Certified Advanced Networking Study Guide (Second Edition)—specifically the security chapters. Although this chapter focuses on AWS-specific security components, many of the concepts discussed apply broadly to general security principles outside of the AWS context.

---
Security compliance is a critical aspect of cloud engineering. It is important to meet requirements at multiple levels:
- **Internal compliance** within your organization.
- **Legal and regulatory compliance** in the countries where your organization or customers operate.
- **Industry-specific regulations**, such as those in finance and healthcare.  

## Compliance Automation  

Automation can be leveraged for compliance checking by using AWS-provided tools and services to enforce security policies. Examples include:  

- **AWS Config**: Monitors resource configurations, tracks changes, and enforces compliance with security standards (e.g., HIPAA, PCI DSS, GDPR).  
- **AWS CloudFormation**: Enables secure, repeatable, and compliant resource deployment.  
- **AWS Security and Compliance Services**:  
  - **Audit Manager, Detective, Inspector, GuardDuty, CloudTrail, Security Hub, CloudWatch** – Help track and analyze network activity.  
- **AWS Identity and Access Management (IAM)**:  
  - IAM securely manages access to AWS resources, enforcing the principle of **least privilege** to minimize security risks.  
- **Amazon Virtual Private Cloud (VPC)**:  
  - Allows for the definition and control of logically isolated cloud-based networks.  
- **AWS Firewall Manager**:  
  - Provides centralized firewall rule management across multiple AWS accounts and VPCs, enforcing security policies.  
- **AWS Security Hub**:  
  - A unified dashboard offering visibility into security alerts and compliance issues, integrating data from GuardDuty, AWS Config, and other AWS services.  
- **Amazon Inspector**:  
  - Performs automated security assessments to detect software vulnerabilities and provide recommendations.  

---

## Threat Models  

Threat models help identify and mitigate potential security threats to networks, applications, and services.  

### **Monolithic Architecture**  
![Monolithic Architecture](/images/Security_Compliance_Governance_images/image.png)  

A monolithic architecture consists of tightly coupled application components that often run on the same EC2 instance or server.  

**Security Considerations:**  
- Focus on OS vulnerabilities, privilege escalations, middleware security, and database security.  
- Common threats: **Denial of Service (DoS), SQL injection, cross-site scripting (XSS), and privilege escalation attacks**.  

---

### **Microservices Architecture**  
![Microservices Architecture](/images/Security_Compliance_Governance_images/image-1.png)  

In a microservices architecture, applications are broken into smaller, discrete components that communicate via API calls.  

**Security Considerations:**  
- The **service mesh** managing communication between microservices must be secured.  
- API vulnerabilities need to be assessed and mitigated.  

---

### **Serverless Architecture**  
![Serverless Architecture](/images/Security_Compliance_Governance_images/image-2.png)  

Serverless applications consist of individual functions triggered by specific events.  

**Security Considerations:**  
- Threat models focus on **insecure function configurations, inadequate access controls, limited application visibility**, and **API security**.  

---

### **Containerized Architecture**  
![Containerized Architecture](/images/Security_Compliance_Governance_images/image-3.png)  

Applications are broken into containerized components managed by orchestration platforms like **Kubernetes**.  

**Security Considerations:**  
- Focus on **container image security, Kubernetes cluster security, and network connections between containers**.  

---

### **Edge Computing Architecture**  
![Edge Computing Architecture](/images/Security_Compliance_Governance_images/image-4.png)  

Applications run on **compute resources located at the edge of the network**, closer to end users.  

**Security Considerations:**  
- Threat models must address **Distributed Denial of Service (DDoS) attacks, data exfiltration, and unauthorized access** to edge computing resources.  

---

## Common Security threats

Cloud computing has many of the same threats you face in your on-premise:

- **Account hijacking**: attacker gains access to an authorized user's acount. This can be achieved with phishing attacks, brute-force attacks, man-in-the-middle exploits, and other methods.
- **Advanced persistent threats**: targeted attacks to steal data or disrupt operations on a long term. Advanced persistent threats are typically carried out by sophisticated attackers.
- **Cryptojacking**: attackers use the computing resources of the victim's infrastructure to mine cryptocurrency.
- **Data breaches**: company's data is accessed, stolen or exposed without your permission or authorization.
- **Denial-of-service**: disrupting the normal functioning of a network, server or website by overwhelming it with traffic or other malicious activity.
- **Insider threats**: an employee or other authorized user either intentionally or unintenionally causes harm to the system.
- **Malware and viruses**: programs designed to cause harm to systems and networks. Can be spread through email attachments, malicious websites, etc.
- **Misconfigured security controls**: create openings for attacks to your AWS infrastructure. Misconfigured security include: improperly configured access controls, network security groups, improperly configured encryption settings
- **Vulnerable third-party Applications**: vulnerabilities in third party applications make your application vulberable as well
- **Unauthorized access**: attacker gains access to your operations sensitive data and systems without proper permission.

AWS solutions: IAM GuardDuty, Inspector, Web Application Firewall (WAF) and many others.


---

## **Securing Application Flows**  

### **Network Security in AWS**  
Network security ensures that traffic flowing through a network is **protected from tampering and theft**. 

### **Securing Traffic in Transit: SSL/TLS**  
- The **Secure Sockets Layer (SSL) / Transport Layer Security (TLS)** protocols are used to encrypt data in transit over the Internet.  
- AWS services that support **SSL/TLS encryption** for application traffic:
  - **Elastic Load Balancing (ELB)**  
  - **CloudFront**  
  - **API Gateway**  
- AWS **CloudFront Edge locations** include an **SSL security certificate** bound to the `cloudfront.net` domain, which can be enabled in the CloudFront distribution settings.  

### **AWS Virtual Private Cloud (VPC) Security**  
An **AWS VPC (Virtual Private Cloud)** is an **isolated network** that allows organizations to enforce security controls.  

#### **Key VPC Security Features**  
1. **Security Groups (SGs)**  
   - Acts as a **virtual firewall** for **EC2 instances**.  
   - Controls **inbound and outbound** traffic.  
   - Rules define **allowed IP addresses, protocols, and ports**.  

2. **Network Access Control Lists (NACLs)**  
   - **Stateless network filters** applied at the **subnet level**.  
   - Filters **inbound and outbound** traffic.  
   - Can **block specific IPs or protocols** for granular control.  

3. **AWS Web Application Firewall (WAF)**  
   - Protects against **SQL injection, cross-site scripting (XSS), and other web attacks**.  
   - Customizable rules to **block specific traffic patterns**.  

4. **Identity and Access Management (IAM)**  
   - Core AWS service for **controlling access to AWS resources**.  
   - Administrators define **users, groups, roles, and permissions**.  

### **Data Encryption & Key Management**  
AWS provides multiple encryption services to **protect data at rest and in transit**.  

- **Encryption Services:**
  - **Amazon EBS Encryption** – Encrypts data stored on **Elastic Block Store** volumes.  
  - **Amazon S3 Encryption** – Encrypts objects stored in **Amazon S3**.  
  - **AWS Key Management Service (KMS)** – Manages **encryption keys** for securing data.  
  - **AWS Certificate Manager (ACM)** – Automates the creation, storage, and renewal of **SSL/TLS certificates**.  

### **AWS Security & Compliance Tools**  

1. **Application Security Services**  
   - **GuardDuty** – Detects **malicious activity** and **unauthorized access**.  
   - **Inspector** – Scans workloads for **security vulnerabilities**.  
   - **Lambda** – Can be used to **deploy secure serverless applications**.  

2. **Logging & Monitoring Services**  
   - **AWS CloudTrail** – Tracks **user activity and API calls**.  
   - **AWS Config** – Monitors **resource configurations** and **compliance**.  
   - **Amazon CloudWatch** – Provides **real-time monitoring, alarms, and event logging**.  

---

## **Securing Inbound Traffic Flows**  

### **Web Application Firewall (WAF)**  

AWS Web Application Firewall (WAF) is designed to **protect web applications** from common web exploits and attacks. It acts as a security layer between the **Internet and AWS-hosted web applications**, filtering and monitoring incoming and outgoing traffic.  

### **Key Features & Protections**  
- Shields applications from **SQL injection, HTTP header modifications, cross-site scripting (XSS), and DDoS attacks**.  
- Integrated with **CloudFront, Application Load Balancer (ALB), and API Gateway**, allowing protection across different AWS services.  
- Offers **preconfigured rules** that AWS updates regularly to adapt to emerging threats.  
- Supports **custom rules** to filter requests based on:  
  - Requesting **URL, query parameters, and request body**.  
  - **Source or destination IP addresses, geographic locations, and port numbers**.  

### **Traffic Monitoring & Logging**  
- Provides **detailed logging and traffic analysis** to help identify patterns and detect suspicious activity.  
- Enables administrators to fine-tune security policies based on real-time data.  

---

### **AWS Network Firewall Overview**  

The **AWS Network Firewall** is a **managed network security service** that provides traffic filtering and monitoring at the **VPC level**. It acts as a **perimeter firewall** that can be deployed **inside a VPC or in front of multiple VPCs**.  

AWS Network Firewall operates at two levels:  
1. **Stateless Firewall** – Inspects each packet **individually**, without tracking previous packets.  
2. **Stateful Firewall** – Tracks **entire sessions**, allowing more advanced security analysis.  

---

![alt text](/images/Security_Compliance_Governance_images/image-5.png)

This diagram explains how AWS Network Firewall processes network traffic. Here's how it works:  

1. **Traffic first enters the Stateless Firewall Engine**  
   - This firewall **inspects each packet in isolation** without considering whether it belongs to an existing session.  
   - The stateless engine evaluates traffic **based on priority rules** you define.  
   - If a packet **matches a rule that blocks it**, it is **dropped immediately**.  
   - If a packet is **allowed**, it **passes through** the firewall (green line).  
   - If the stateless firewall does not make a final decision, it **forwards the packet to the stateful firewall for deeper inspection**.  

2. **Traffic forwarded to the Stateful Firewall Engine**  
   - The stateful firewall **tracks sessions** and evaluates the flow as a whole, rather than inspecting individual packets separately.  
   - It uses a **default rule order:**
     - **Pass (Allow)**
     - **Drop (Block)**
     - **Alert (Log the attempt but do not block)**  
   - If the packet is **allowed**, it **continues its path**.  
   - If the packet is **blocked**, it is **dropped immediately**. 
   - If an **alert rule** applies, the packet may still be allowed but logged for further analysis.  

---

## **Securing Inbound Traffic Flows**  

### **AWS Shield – DDoS Protection**  
AWS Shield is a **managed Distributed Denial of Service (DDoS) protection service** that defends applications against **volumetric, protocol, and application-layer attacks**.  

#### **Shield Tiers**  
1. **AWS Shield Standard**  
   - **Automatically enabled** *(Free Service)*  
   - Protects against **common and frequent** network-layer and transport-layer DDoS attacks.  

2. **AWS Shield Advanced** *(Paid Service)*  
   - Provides **enhanced protection** for **Internet-facing applications** on **EC2, ELB, CloudFront, Global Accelerator, and Route 53**.  
   - Includes **real-time visibility, automated mitigation, and 24/7 support from the AWS DDoS Response Team (DRT)**.  
   - Requires **Enterprise or Business AWS Support Plan**.  

AWS Shield integrates with **Elastic Load Balancers, CloudFront, Global Accelerator, EC2, and Route 53** to **mitigate DDoS threats before they impact application availability**.  

---

### **Security Groups – Instance-Level Security**  
- **Security Groups (SGs) act as virtual firewalls** that **control inbound and outbound traffic** at the **instance level** within a VPC.  
- **Stateful** – If inbound traffic is allowed, the response traffic is **automatically permitted**.  
- **Configured to allow traffic based on:**  
  - **IP addresses**  
  - **Protocols (TCP, UDP, etc.)**  
  - **Port numbers**  

#### **Common Security Group Configurations**  
- **Inbound Security Group:**  
  - Allows **web (HTTP/HTTPS) and SSH access** to servers in a public subnet.  
- **Outbound Security Group:**  
  - Allows **SSL (HTTPS) and SSH traffic** to exit the VPC to the Internet.  

---

### **Network Access Control Lists (NACLs) – Subnet-Level Security**  
- **NACLs operate at the subnet level** to control **inbound and outbound traffic**.  
- **Stateless** – Each rule applies **independently** to inbound and outbound traffic, meaning **separate rules must be defined for each direction**.  
- Can **allow or deny traffic** based on:  
  - **Source and destination IP addresses**  
  - **Port numbers**  

#### **Common NACL Configurations**  
- **Inbound NACL:**  
  - Allows **HTTP/HTTPS and SSH access** to public-facing servers.  
- **Outbound NACL:**  
  - Allows **SSL (HTTPS) and SSH traffic** to exit the VPC to the Internet.  

To enforce NACL rules, they must be **associated with a subnet** in the VPC.  

---

### **Key Differences: Security Groups vs. NACLs**  

| Feature | Security Groups | NACLs |
|---------|---------------|-------|
| **Level** | Instance level | Subnet level |
| **Statefulness** | **Stateful** (Automatically allows return traffic) | **Stateless** (Inbound & outbound rules must be explicitly defined) |
| **Default Behavior** | Denies all inbound, allows all outbound | Allows all inbound and outbound by default |
| **Use Case** | Controls access **to individual EC2 instances** | Controls access **to entire subnets** |

---

## **Securing Outbound Traffic Flows**  

Securing outbound traffic in AWS is crucial for **compliance, data protection, and threat prevention**. Outbound traffic filtering helps prevent **unauthorized data transfers, malware infections, and security breaches**. Many compliance regulations also require organizations to **monitor and control** outbound traffic to prevent **data loss and unauthorized access**.  

### **Best Practices for Securing Outbound Traffic**  

1. **Network Segmentation**  
   - Isolates sensitive data to **restrict and control** outbound flows.  
   - Reduces risk of unauthorized access or data exfiltration.  

2. **Network Access Control Lists (NACLs)**  
   - Controls outbound traffic at the **subnet level** by **allowing or denying** access based on IP addresses, protocols, and ports.  
   - Unlike security groups, **NACLs are stateless**, meaning **explicit rules must be set for both inbound and outbound traffic**.  

3. **Proxy Servers**  
   - Acts as an **intermediary** between **client devices and external resources**.  
   - **Filters and inspects** traffic for **malicious content** before it leaves the VPC.  
   - Helps enforce **security policies** and **logs all outgoing requests**.  

4. **Route 53 DNS Resolvers**  
   - AWS-managed **DNS service** that controls **outbound DNS queries**.  
   - Blocks traffic to **known malicious domains** and ensures **queries go only to trusted domains**.  

5. **AWS PrivateLink (VPC Endpoint Services)**  
   - **Prevents outbound traffic from exposing data to the public Internet**.  
   - Provides **private access** to AWS services within the **AWS network** instead of routing through the Internet.  

6. **Gateway Load Balancers**  
   - Used to **filter, inspect, and distribute outbound traffic** securely.  
   - Supports **third-party security appliances** for **intrusion detection, SSL/TLS encryption, and access control policies**.  

7. **AWS Virtual Private Network (VPN)**  
   - Encrypts outbound traffic **between the VPC and remote endpoints**.  
   - Ensures **data remains protected** while traveling over the Internet.  
   - Prevents **unauthorized access** to outbound traffic flows.  

8. **AWS Network Firewall**  
   - **Filters and inspects outbound traffic** using **stateful rules**.  
   - Can **block traffic from known malicious sources** and filter based on **IP addresses, ports, protocols, and geo-locations**.  

9. **Monitoring & Logging Outbound Traffic**  
   - **Amazon VPC Flow Logs** track **all outbound traffic activity**.  
   - Helps **detect unauthorized access or suspicious activity**.  
   - Logs can be integrated with **AWS Security Hub and SIEM tools** for analysis.  

---

## **Securing Inter-VPC Traffic**  

Securing **inter-VPC traffic** within an AWS account or across multiple accounts requires **network-level security measures** (like **security groups and NACLs**) and **application-level security measures** (like **VPC endpoint policies and PrivateLink**). Implementing **layered security controls** helps ensure that traffic between VPCs remains **protected from unauthorized access and potential threats**.  

---

### **Key Security Components for Inter-VPC Traffic**  

### **1. Network Access Control Lists (NACLs)**  
- **Stateless firewall** that controls traffic **at the subnet level**.  
- Used to **allow or deny** traffic **between VPCs** based on:  
  - **Source & destination IP addresses**  
  - **Port numbers**  
  - **Protocols (TCP, UDP, ICMP, etc.)**  
- Can be implemented **within the same account** or **across multiple AWS accounts** to restrict inter-VPC traffic.  

---

### **2. VPC Endpoint Policies**  
- **VPC endpoints allow private connections** between a VPC and AWS services **without requiring an Internet gateway, NAT device, VPN, or AWS Direct Connect**.  
- **VPC endpoint policies** define access control rules for **who can access** the VPC endpoint, ensuring:  
  - Only **authorized services or accounts** can connect.  
  - Unwanted or **external traffic is blocked** from reaching the endpoint.  
- Essential for **controlling inter-VPC traffic across multiple accounts** securely.  

---

### **3. Security Groups**  
- **Stateful firewalls** that filter inbound and outbound traffic **at the instance level**.  
- Can be used to **allow or block traffic** between VPCs **within the same AWS account or across accounts**.  
- Security groups allow:  
  - **Defining trusted IP ranges** for inter-VPC communication.  
  - **Restricting access** from known malicious sources.  
  - **Allowing traffic only on specific ports and protocols**.  

---

### **4. AWS Transit Gateway**  
![alt text](/images/Security_Compliance_Governance_images/image-8.png)
- A **network transit hub** that simplifies **multi-VPC connectivity**.  
- **Connects multiple VPCs** within the same account or across different AWS accounts.  
- Enables **centralized routing and security policies**, ensuring that inter-VPC traffic remains secure.  
- Supports **low-latency and high-bandwidth** connections for better performance.  

---

### **5. VPC Peering** 
![alt text](/images/Security_Compliance_Governance_images/image-7.png) 
- **Direct private connection** between **two VPCs** within the same AWS account or across multiple accounts.  
- Uses the **AWS internal network** for routing, ensuring **low-latency and high-speed communication**.  
- **Security Considerations for VPC Peering:**  
  - **Traffic between peered VPCs does not traverse the public Internet**, reducing security risks.  
  - **No transitive peering** – meaning for one VPC (VPC A) to reach another one (VPC C) it cannot traverse through another VPC (VPC B), **Transit Gateway** is a better solution.  


**Quick comparisson between VPC Peering and Transit Gateway**
![alt text](/images/Security_Compliance_Governance_images/image-6.png)


---
## **Implementing an AWS Network Architecture to Meet Security and Compliance Requirements**  

![alt text](/images/Security_Compliance_Governance_images/image-9.png)

### **1. Untrusted Network (DMZ Architecture)**  
- Also known as a **Demilitarized Zone (DMZ)**, this architecture **isolates public-facing resources** from the internal network.  
- Typically used for **web servers, public APIs, or any service accessible from the Internet**.  
- Security is enforced through:  
  - **Security Groups & NACLs** – Restrict access to internal resources.  
  - **VPC Endpoint Policies** – Control which AWS services can be accessed.  
  - **Data Encryption** – Protects data in transit and at rest.
  - The Untrusted VPC acts as an **intermediary** between the Internet and internal AWS resources.  
- **Traffic from the Internet can only access the DMZ but not internal networks**, reducing exposure to threats.  

---
![alt text](/images/Security_Compliance_Governance_images/image-10.png)
### **2. Perimeter VPC Architecture**  
- A **dedicated VPC acts as a security perimeter** around other VPCs in the AWS environment.  
- **Purpose:** Protect the internal network from **external threats** while **controlling access** to services.  
- Security controls:  
  - **AWS Transit Gateway** – Connects the **perimeter VPC** to other VPCs securely.  
  - **Security Groups & NACLs** – Restrict inbound and outbound traffic.  
  - **VPC Endpoint Policies** – Enforce security policies for AWS services.  
- The **Perimeter VPC** hosts **firewalls, intrusion detection systems, and security monitoring tools**.  

---
![alt text](/images/Security_Compliance_Governance_images/image-11.png)
### **3. Three-Tier Architecture**  
- **Divides applications into three separate network tiers:**  
  1. **Web Tier (Public Subnet)** – Hosts web servers, accessible from the Internet.  
  2. **Application Tier (Private Subnet)** – Handles business logic, communicates with web and database tiers.  
  3. **Database Tier (Private Subnet)** – Stores sensitive data, only accessible by the application tier.  
- **Security Measures:**  
  - **Security Groups & NACLs** – Restrict traffic flow between tiers.  
  - **VPC Endpoint Policies** – Ensure private communication with AWS services.  
  - **Data Encryption** – Protects sensitive information at rest and in transit.  
- **Benefit:** Enhances **scalability, security, and isolation of application components**.  

---
![alt text](/images/Security_Compliance_Governance_images/image-12.png)
### **4. Hub-and-Spoke Architecture**  
- Uses a **central Hub VPC** to manage traffic **between multiple Spoke VPCs**.  
- **AWS Transit Gateway** is used to connect the Hub VPC to multiple Spoke VPCs securely.  
- **Security Controls:**  
  - **Security Groups & NACLs** – Control access between Hub and Spoke VPCs.  
  - **VPC Endpoint Policies** – Restrict access to AWS services.  
- **Benefits:**  
  - **Simplifies management** of multiple VPCs.  
  - **Improves security** by centralizing monitoring and access control.  