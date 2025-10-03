+++
title = "Detecting Linux Attacks with Splunk SIEM"
date = 2025-04-16
draft = false
description = "A practical guide to detecting SSH brute force, SUID abuse, persistence, and exfiltration using Splunk, auditd, and custom SPL queries"
categories = ["SIEM", "Splunk", "Linux Security", "Cybersecurity"]
authors = ["Abdulla Bagishev"]
image = "/images/splunk_dashboard/splunk.png"
avatar = "/images/AE.svg"
+++

# The Importance of SIEM (Security Information and Event Management)

In this post, I'll be going through the importance of a SIEM. A SIEM allows us to analyze systems, understand their behavior, and recognize dangerous patterns. In this blog, I'll keep it simple. We'll go over:

- Why a SIEM is important  
- What it's used for  
- A basic custom dashboard example with a few key detections  

---

## Why Use a SIEM?

A SIEM centralizes logs from systems and services across your infrastructure. It gives you visibility into:

- Who is logging in?
- What commands are being run?
- Is anyone trying to brute force their way in?
- Are there signs of persistence, privilege escalation, or exfiltration?

It becomes your eyes into your systems' behavior and potential threats.

---

## Lab Setup Overview

For this lab:
- SIEM Platform: **Splunk Enterprise** running on a **Ubuntu Server**
- Client Machine: **Rocky Linux 9** (rocky-web01)  (rsyslog + auditd forwarding)
- Attacker Machine: **Kali Linux** (mainly for SSH brute force)

---

## Auditd Rules Setup

To enable detailed system monitoring, I created a custom audit ruleset located at:

```
/etc/audit/rules.d/audit.rules
```

Click below to expand audit.rules {{< details >}}
<details>
<summary><strong>📜 Click to expand audit.rules</strong></summary>

```bash
-D
-b 8192
-f 1
--backlog_wait_time 60000

## === EXECUTION ===
-a always,exit -F arch=b64 -S execve -k exec_log
-a always,exit -F arch=b32 -S execve -k exec_log
-w /bin/bash -p x -k bash_exec
-w /bin/sh -p x -k sh_exec
-w /usr/bin/nc -p x -k netcat_use
-w /usr/bin/ncat -p x -k netcat_use
-w /usr/bin/ssh -p x -k ssh_use

## === PRIV ESCALATION ===
-a always,exit -F arch=b64 -S setuid,setgid -k priv_esc
-a always,exit -F arch=b32 -S setuid,setgid -k priv_esc

## === PERSISTENCE ===
-w /etc/cron.allow -p wa -k cron_mod
-w /etc/cron.d/ -p wa -k cron_mod
-w /etc/cron.daily/ -p wa -k cron_mod
-w /etc/crontab -p wa -k cron_mod
-w /etc/systemd/system/ -p wa -k systemd_backdoor
-w /etc/rc.local -p wa -k rc_persistence

## === LOG TAMPERING ===
-w /var/log/ -p wa -k log_tamper
-w /root/.bash_history -p wa -k history_clear
-w /home/abdullah/.bash_history -p wa -k history_clear

## === EXFILTRATION ===
-w /usr/bin/scp -p x -k exfil
-w /usr/bin/wget -p x -k exfil
-w /usr/bin/curl -p x -k exfil
-w /usr/bin/ftp -p x -k exfil
-w /usr/bin/sftp -p x -k exfil

## === NETWORK ACTIVITY ===
-a always,exit -F arch=b64 -S connect -k netconn
-a always,exit -F arch=b32 -S connect -k netconn
-a always,exit -F arch=b64 -S socket -k socket_create
-a always,exit -F arch=b32 -S socket -k socket_create

## === PROCESS ACTIVITY ===
-a always,exit -F arch=b64 -S fork,vfork,clone -k proc_spawn
-a always,exit -F arch=b32 -S fork,vfork,clone -k proc_spawn

## === SSH BRUTEFORCE LOGGING ===
-w /var/log/secure -p r -k ssh_brute

```
</details>
{{< /details >}}

This ruleset enables logging for:

- **Program execution** (`execve`, `/bin/bash`, `/bin/sh`)
- **Privilege escalation** (`setuid`, `chmod +s`)
- **Persistence techniques** (modifications to `cron.d`, `rc.local`, `systemd`)
- **Sensitive file access** (e.g., `/etc/shadow`, `.bash_history`)
- **Temp file execution** (`/tmp`, `/var/tmp`, `/dev/shm`)
- **Network activity** (e.g., `connect`, `socket`)
- **Exfiltration tools** (`scp`, `curl`, `wget`, `ftp`)

These audit rules allow Splunk to receive enriched log events from `auditd` via `rsyslog`, providing full visibility into attacker behavior without requiring agents or kernel modules.

---

## Dashboard Overview

Below is the custom dashboard I created in Splunk. It covers detections such as SSH brute force, sudo usage, SUID escalation, persistence via cron, suspicious temp files, and data exfiltration.

![Splunk Dashboard](/images/splunk_dashboard/dashboard.png)

---

## 1. Sudo Commands Executed

We log all `sudo` command executions to monitor privileged access usage.

![Sudo Commands](/images/splunk_dashboard/image.png)

**SPL:**
```spl
index="linux_logs" sourcetype="syslog" host="rocky-web01" "sudo"
| rex field=_raw "sudo\\[\\d+\\]: (?<executing_user>[^ ]+) : TTY=[^;]+ ; PWD=(?<pwd>[^;]+) ; USER=(?<user>[^;]+) ; COMMAND=(?<command>.+)"
| where isnotnull(command)
| table _time executing_user user pwd command
| sort -_time
```

---

## 2. SSH Brute Force Attempts

We monitor failed SSH logins, highlighting brute-force attempts.
![Failed SSH](/images/splunk_dashboard/image-1.png)
![alt text](/images/splunk_dashboard/image-3.png)
**SPL:**
```spl
index="linux_logs" sourcetype="syslog" "authentication failure"
| stats count as "SSH Failures"
```

and 

```spl
index="linux_logs" sourcetype="syslog" "sshd" "Failed password"
| rex "Failed password for (invalid user )?(?<username>\w+) from (?<attacker_ip>\d+\.\d+\.\d+\.\d+)"
| stats count by attacker_ip
| sort -count
```
---

## 3. Successful SSH Logins

This helps confirm who successfully logged in via SSH and from where.
![Successful Logins](/images/splunk_dashboard/image-2.png)
**SPL:**
```spl
index="linux_logs" sourcetype="syslog" "sshd" ("USER_START" OR "USER_AUTH")
| rex "acct=\"(?<user>[^\"]+)"
| rex "addr=(?<ip>\d+\.\d+\.\d+\.\d+)"
| rex "exe=\"(?<exe>[^\"]+)"
| search res=success exe="/usr/sbin/sshd"
| dedup _time, user, ip
| table _time, host, user, ip
| sort -_time
```

---

## 4. SUID Privilege Escalation Attempts

Executed SUID binaries and suspicious `chmod +s` events are flagged.
![SUID](/images/splunk_dashboard/image-4.png)
**SPL:**
```spl
index="linux_logs" sourcetype="syslog" ("type=EXECVE" OR "type=SYSCALL") ( "chmod" OR "u+s" )
| rex field=_raw "msg=audit\\((?<audit_id>[^)]+)\\):"
| eventstats values(_raw) as all_logs by audit_id
| eval joined = mvjoin(all_logs, " ")
| rex field=joined "(?<uid_field>(A|E|F|S)?UID)=\"?(?<user>[^\\s\"]+)\"?"
| rex field=joined "a2=\\\"(?<target_file>[^\"]+)"
| stats latest(_time) as _time values(user) as user values(target_file) as target_file values(host) as host by audit_id
| table _time host user target_file
```

---

## 5. Cron Job Persistence

We watch for file modifications or executions under cron directories.
![cron](/images/splunk_dashboard/image-5.png)
**SPL:**
```spl
index="linux_logs" sourcetype="syslog" host="rocky-web01"
"COMMAND=" "/etc/cron.d"
| rex "COMMAND=(?<command>.+)"
| rex "sudo\\[\d+\\]: (?<user>\w+)"
| where isnotnull(command) AND isnotnull(user)
| table _time, host, user, command
| sort -_time
```

---

## 6. Temp File Executions

Common post-exploitation tools or malware may run from `/tmp`, `/var/tmp`, or `/dev/shm`.
![temp_exec](/images/splunk_dashboard/image-6.png)
**SPL:**
```spl
index="linux_logs" sourcetype="syslog" ("/tmp/" OR "/dev/shm/" OR "/var/tmp/")
| rex "a1=\"(?<executed>[^\"]+)"
| where like(executed, "/tmp/%") OR like(executed, "/dev/shm/%") OR like(executed, "/var/tmp/%")
| table _time, host, executed
| dedup _time, host, executed
| sort -_time
```

---

## 7. Exfiltration Attempts (via curl, scp)

Detects data being posted or copied out of the system.
![exfilt_attempts](/images/splunk_dashboard/image-7.png)
**SPL:**
```spl
index="linux_logs" sourcetype="syslog" ("curl" OR "scp")
| rex "COMMAND=(?<command>.+)"
| search command="*POST*" OR command="*scp*" OR command="*/etc/shadow*"
| table _time, host, user, command
| sort -_time

```

---

## Mapping to MITRE ATT&CK

This detection lab maps to multiple MITRE ATT&CK techniques, including:

| Technique | Description                         | Covered by                                      |
|-----------|-------------------------------------|-------------------------------------------------|
| T1078     | Valid Accounts                      | Successful SSH login tracking                   |
| T1110.001 | Brute Force: Password Guessing      | SSH brute force detection                       |
| T1059     | Command and Scripting Interpreter   | `execve`, bash/sh audit rules                   |
| T1547.001 | Boot or Logon Autostart via cron    | Cron job modification detection                 |
| T1546.004 | Event Triggered Execution: systemd  | Watching `/etc/systemd/system`                  |
| T1055     | Process Injection (via SUID abuse)  | Detection of SUID privilege escalation attempts |
| T1041     | Exfiltration over C2 channel        | Curl, scp-based exfiltration detection          |

---

## Conclusion

This lab demonstrates how a SIEM can provide immediate visibility into system behavior and attacker activity. With even minimal log sources and audit rules, we can:

- Spot brute-force attempts
- Trace sudo and SUID activity
- Detect cron-based persistence
- Monitor critical file access
- Flag temp path execution
- Log exfiltration patterns

With more data and tuning, this can evolve into a highly effective detection and response platform. This project reflects real-world detection use cases and demonstrates hands-on skills in log analysis, Splunk SPL and Linux internals.
