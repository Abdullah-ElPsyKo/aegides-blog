+++
title = "Ethical Hacking: Magnum Opus - LLMNR Poisoning"
date = 2024-12-20
draft = false
description = "Een showcase van LLMNR poisoning en de impact op cybersecurity."
categories = ["Cybersecurity", "Ethical Hacking", "Networking"]
authors = ["Abdulla Bagishev"]
image = "/images/LLMNRicon.png"
imageBig = "/images/LLMNR.png"
avatar = "/images/AE.svg"
+++

# Ethical Hacking: Magnum Opus - LLMNR Poisoning  
**Auteur: Abdulla Bagishev**  
**Jaar: 2024-2025**  
**Onderwerp: Cybersecurity en netwerkbeveiliging**  

---

## Inleiding
Link-Local Multicast Name Resolution (LLMNR) is een netwerkprotocol dat wordt gebruikt in Windows-netwerken om hostnamen te resolven wanneer een DNS-server niet beschikbaar is. Hoewel LLMNR functioneel waardevol is, introduceert het een significante kwetsbaarheid die kan worden misbruikt door aanvallers om gevoelige informatie te onderscheppen, zoals inloggegevens en netwerkverkeer.

In deze paper onderzoeken we hoe LLMNR-poisoning werkt en demonstreren we hoe een aanvaller de zwakheden in dit protocol kan uitbuiten. Daarnaast behandelen we:

- Hoe LLMNR functioneert en waarom het kwetsbaar is.
- Implementatie van een **Python-script** om LLMNR-verzoeken te onderscheppen.
- Hoe **tools zoals Responder** kunnen worden ingezet voor LLMNR-exploits.
- Methoden om LLMNR-poisoning **te detecteren en te voorkomen**.

---

## 1. Technische Achtergrond
### 1.1 Wat is LLMNR?
LLMNR is een **fallback-mechanisme** voor het resolven van hostnamen in lokale netwerken wanneer DNS niet beschikbaar is. Het protocol maakt gebruik van **multicast UDP-verkeer** op poort 5355.

### 1.2 Hoe werkt LLMNR?
Wanneer een apparaat een hostnaam moet resolven die niet in DNS voorkomt, stuurt het een **multicast-query** naar het netwerk. Alle apparaten ontvangen deze query en kunnen antwoorden als zij de gevraagde hostnaam hebben.

### 1.3 Waarom is LLMNR kwetsbaar?
1. **Geen authenticatie**: Het vertrouwt blind op het eerste antwoord.
2. **Geen encryptie**: Gevoelige data wordt onversleuteld verzonden.
3. **Standaard ingeschakeld**: Op veel Windows-systemen staat LLMNR standaard aan.

### 1.4 Aanvalmechanisme: LLMNR Poisoning
1. Het slachtoffer verstuurt een **LLMNR-query** voor een onbekende hostnaam.
2. De aanvaller **onderschept en beantwoordt de query** met een gespooft IP-adres.
3. Het slachtoffer **stuurt zijn netwerkverkeer** naar de aanvaller.
4. De aanvaller **onderschept wachtwoorden en gevoelige data**.

---

## 2. Threat Model en Aanvalsopzet
### 2.1 Threat Model
- **Aanvallersprofiel**: Interne netwerkaanvallers, pentesters of red-teamers.
- **Doelwitprofiel**: Windows-systemen met **LLMNR ingeschakeld**.
- **Aanvalsvector**: Onbeveiligde netwerken zonder detectie- en preventiemechanismen.

### 2.2 Aanvalsopzet
**Stap 1**: **Netwerkverkenning** - Wireshark gebruiken om LLMNR-verzoeken te detecteren.  
**Stap 2**: **LLMNR Listener opzetten** - Een Python-script of **Responder** configureren.  
**Stap 3**: **Aanval uitvoeren** - Gespoofte LLMNR-responses sturen naar het slachtoffer.  
**Stap 4**: **Interceptie en exploitatie** - NTLM-hashes verzamelen en brute-force aanvallen uitvoeren.  

---

## 3. Implementatie van een LLMNR Listener in Python
### 3.1 Beschrijving van het script
We bouwen een **Python LLMNR Listener** die:
- **Luistert** naar LLMNR-verzoeken op UDP-poort 5355.
- **Spooft** het antwoord met het IP-adres van de aanvaller.
- **Logt** de ontvangen gegevens voor analyse.

### 3.2 Python Code
```python
import socket
import struct
import threading

MCAST_GRP = '224.0.0.252'  # Multicast-adres LLMNR
MCAST_PORT = 5355          # UDP-poort voor LLMNR
REDIRECT_IPv4 = '192.168.1.26'  # IP van aanvaller

def start_llmnr_listener():
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    sock.bind((MCAST_GRP, MCAST_PORT))
    
    print(f"Listening for LLMNR requests on {MCAST_GRP}:{MCAST_PORT}...")
    while True:
        data, addr = sock.recvfrom(1024)
        print(f"[+] Received LLMNR request from {addr}")

threading.Thread(target=start_llmnr_listener, daemon=True).start()
while True:
    pass
```

---

## 4. Demonstratie: Exploit Walkthrough
### 4.1 Testomgeving
- **Aanvallersysteem**: Linux VM met **Python-script of Responder**.
- **Doelsysteem**: Windows VM met **LLMNR ingeschakeld**.
- **Tools**: Wireshark, Responder, Python.

### 4.2 Stap-voor-stap Uitleg
1. **Detecteer LLMNR-verzoeken** in Wireshark (filter: `udp.port == 5355`).
2. **Voer het Python-script uit** om LLMNR-requests te onderscheppen.
3. **Stuur gespoofte antwoorden** en **onderschep authenticatiegegevens**.

---

## 5. Detectie en Preventie
### 5.1 Hoe detecteer je LLMNR-poisoning?
✅ **Gebruik Wireshark** en filter op **UDP-poort 5355**.
✅ **Gebruik IDS/IPS zoals Snort of Suricata**.
✅ **Monitor verdachte verkeer naar ongebruikelijke IP-adressen**.

### 5.2 Hoe voorkom je LLMNR-poisoning?
🚫 **LLMNR uitschakelen in Windows via Group Policy**:  
1. Open **gpedit.msc** > Ga naar `Computer Configuration → Administrative Templates → Network → DNS Client`.
2. **Zet LLMNR op 'Disabled'**.

🔐 **Gebruik beveiligde DNS-protocollen zoals DNSSEC**.

---

## 6. Conclusie
LLMNR-poisoning is een krachtige techniek die kan worden misbruikt in netwerken waar het protocol actief is. Door de combinatie van **een zwak authenticatie-mechanisme en multicast-verkeer** is het een populaire aanvalsmethode onder pentesters en black-hat hackers.

Om dit te mitigeren, moeten organisaties **LLMNR uitschakelen, hun netwerken segmenteren en monitoringtools inzetten**. Dit project toont aan dat een kleine netwerkconfiguratie-fout **grote beveiligingsrisico’s kan opleveren**.

---

## 7. Referenties
- [TCM Security - LLMNR Poisoning Prevention](https://tcm-sec.com/llmnr-poisoning-and-how-to-prevent-it/)
- [SpiderLabs Responder](https://github.com/SpiderLabs/Responder)

