+++  
title = "Securing Networks with pfSense: WAN, LAN, and DMZ Segmentation"  
date = 2025-04-19  
draft = false  
description = "Building a secure network segmentation using pfSense with WAN, LAN, and DMZ on VMware Workstation. Includes firewall rules, GeoIP filtering, and Suricata inline IPS for deep packet inspection."
categories = ["Network Security", "Firewall", "pfSense", "Infrastructure"]  
authors = ["Abdulla Bagishev"]  
image = "/images/pfsense_suricata/pfsense-logo.png"  
avatar = "/images/AE.svg"  
+++  

# Introduction
In this project, I designed a segmented and secure network using **pfSense** as the core firewall/router. The environment was virtualized using **VMware Workstation**, and I relied on **three virtual NICs** for proper interface isolation, since VLAN tagging isn't fully supported in this hypervisor.

I wanted to simulate what a real SMB firewall configuration might look like if done right, even in a basic lab setup.

The goal was to build a realistic home or SMB firewall topology featuring strong zone separation, GeoIP filtering, and Suricata in inline IPS mode for active threat prevention.


---  

## Why Network Segmentation?

Network segmentation is critical to isolate zones of trust and limit lateral movement. It allows you to:

- Expose public services safely (e.g., web server in the DMZ)
- Keep internal assets protected (e.g., LAN)
- Monitor and filter traffic between zones
- Apply stricter firewall rules per segment

---  

## Lab Setup Overview

**Hypervisor**: VMware Workstation  
**Firewall**: pfSense Community Edition  
**Virtual NICs**:  
- NIC 1 = WAN (bridged to internet)  
- NIC 2 = LAN (host-only)  
- NIC 3 = DMZ (host-only)  

**Interfaces** on pfSense:  
- **WAN** – Connected to Internet  
- **LAN** – 192.168.218.1/24 (Trusted internal segment)  
- **DMZ** – 192.168.40.1/24 (Isolated public-facing services)

**Test VMs**:  
- LAN client (Debian machine)  
- DMZ server (Kali machine)

![alt text](/images/pfsense_suricata/image.png)

---  

## Interface Configuration

### WAN

- DHCP from physical network
- Bridged enabled
- Default gateway

### LAN

- Static: `192.168.218.1/24`
- DHCP range: `192.168.218.100 - 192.168.218.200`

### DMZ

- Static: `192.168.40.1/24`
- DHCP range: `192.168.40.100 - 192.168.40.200`

![alt text](/images/pfsense_suricata/image-1.png)
![alt text](/images/pfsense_suricata/image-2.png)

---  

## Firewall Rules

### LAN Rules

- Allow outbound to WAN
- Block DMZ access (default deny)
- Allow internal DNS/DHCP

### DMZ Rules

- Allow inbound HTTP/HTTPS from WAN
- Block LAN access entirely
- Allow DNS out

![alt text](/images/pfsense_suricata/image-3.png) 
![alt text](/images/pfsense_suricata/image-4.png)

---  

## GeoIP Filtering (pfBlockerNG)

To limit inbound access to the DMZ, I used **pfBlockerNG** with **GeoIP blocking** to allow only selected countries.

Steps:

1. Install pfBlockerNG package
2. Enable GeoIP under IP tab
3. Create an alias for not allowed countries (e.g., Russia, China) or head over to the continent and choose countries manually

In my case I will be blocking any inbound and outbound traffic to Russia.
![alt text](/images/pfsense_suricata/image-6.png)
![alt text](/images/pfsense_suricata/image-5.png)

To test this we will go to the popular Russian website: yandex.ru
**Before**
![alt text](/images/pfsense_suricata/image-7.png)

**After**
![alt text](/images/pfsense_suricata/image-8.png)

---  

## Inline IDS/IPS with Suricata

I enabled **Suricata** in inline IPS mode directly on pfSense to inspect and drop malicious traffic.

**Setup Highlights**:

- Suricata enabled on LAN and DMZ
- ET Open Ruleset activated
- Inline mode with Netmap configured (workers mode)
- Rules manually adjusted to drop on: Nmap scan, suspicious HTTP POSTs, shellcode patterns

Note: Suricata defaults to WAN, but that creates a lot of noise. Since pfSense already blocks unsolicited inbound traffic on WAN, Suricata would just log endless scans on closed ports—burning CPU for little value. That’s why I enabled it on the LAN/DMZ interfaces instead, where it can inspect actual allowed traffic.

**Testing & Results**:
- `curl -d 'uid=0(root)'` to internal services triggered **GPL ATTACK_RESPONSE id check returned root** → **[DROP logged]**
- ICMP traffic and malformed packets also correctly alerted or blocked

![alt text](/images/pfsense_suricata/image-9.png)

---  

## Isolation Testing

- LAN to WAN: ✅
- LAN to DMZ: ❌ (blocked as expected)
- DMZ to WAN: ✅
- DMZ to LAN: ❌ (blocked)
- Internet to DMZ (HTTP): ✅ (if port-forwarded)


---  

## Limitations & Notes

- VMware Workstation doesn’t support VLAN tags the same way ESXi does. That’s why physical NIC segmentation (three vNICs) was chosen.

---  

## Future Work

This pfSense project lays the foundation. Here’s how I plan to expand it:

- Forward logs to **Splunk**
- Enable **VPN (OpenVPN or WireGuard)** access from WAN to LAN

---  

## Conclusion

This project demonstrates a realistic deployment of pfSense as a firewall with clear network segmentation and secure policy enforcement. Even without VLAN tagging, zone isolation was achieved with multiple NICs and enforced strict traffic filtering. GeoIP filtering and inline Suricata IPS further tightened the perimeter.

It’s a strong foundation for extending toward a full-blown network security lab.

![alt text](/images/pfsense_suricata/image-10.png)

