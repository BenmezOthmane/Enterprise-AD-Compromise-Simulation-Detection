# Incident Report — Enterprise AD Compromise
**Classification:** CRITICAL  
**Date:** March 2026  
**Prepared by:** Othmane Benmezian  
**Environment:** SOC.local — Windows Server 2022 AD Lab  

---

## Executive Summary

A full Active Directory compromise was simulated across 4 phases,
starting from an unauthenticated attacker on the network segment
and ending with complete Domain Admin access and credential dumping
of all 28 domain accounts including Administrator and krbtgt.

Every phase was detected by Wazuh SIEM with custom detection rules
mapped to MITRE ATT&CK framework.

---

## Attack Sequence

| Step | Phase | Action | Result |
|---|---|---|---|
| 1 | Initial Access | LLMNR Poisoning | testuser hash |
| 2 | Credential Access | Kerberoasting | svc-mssql hash |
| 3 | Lateral Movement | Pass-the-Hash | WORKSTATION01 access |
| 4 | Privilege Escalation | DCSync | Domain compromised |

---

## Attack Chain
```
Initial Access
└── LLMNR Poisoning (T1557.001)
    └── Credential Access
        └── Kerberoasting (T1558.003)
            └── Lateral Movement
                └── Pass-the-Hash (T1550.002)
                    └── Privilege Escalation
                        └── DCSync (T1003.006)
                            └── DOMAIN COMPROMISED
```

---

## Phase Details

### Phase 1 — LLMNR/NBT-NS Poisoning
- **Technique:** T1557.001
- **Tool:** Responder
- **Result:** NTLMv2 hash captured → Password123
- **Detection:** Wazuh Rule 100001 — Event ID 4648
- **Severity:** HIGH

### Phase 2 — Kerberoasting
- **Technique:** T1558.003
- **Tool:** Rubeus v2.2.0
- **Result:** TGS ticket extracted → Password1
- **Detection:** Wazuh Rule 100010 — Event ID 4769 RC4
- **Severity:** HIGH

### Phase 3 — Pass-the-Hash
- **Technique:** T1550.002
- **Tool:** CrackMapExec, smbclient.py
- **Result:** ADMIN$, C$, IPC$ access on WORKSTATION01
- **Detection:** Wazuh Rule 92652 — Event ID 4624 NTLM
- **Severity:** CRITICAL

### Phase 4 — Privilege Escalation via DCSync
- **Technique:** T1003.006, T1078.002
- **Tool:** dacledit.py, secretsdump.py
- **Result:** All 28 domain hashes dumped
- **Detection:** Wazuh Rule 100031 — Event ID 4662
- **Severity:** CRITICAL

---

## Affected Accounts

| Account | Type | Compromised |
|---|---|---|
| testuser | Domain User | ✅ Password123 |
| svc-mssql | Service Account | ✅ Password1 |
| Administrator | Domain Admin | ✅ Hash dumped |
| krbtgt | Kerberos Account | ✅ Hash dumped |
| User1-User20 | Domain Users | ✅ Hashes dumped |
| DC-022$ | Computer Account | ✅ Hash dumped |

---

## Detection Summary

| Rule ID | Level | Technique | Fired |
|---|---|---|---|
| 100001 | 10 | T1557.001 LLMNR | ✅ |
| 100010 | 14 | T1558.003 Kerberoasting | ✅ |
| 92652 | 6 | T1550.002 Pass-the-Hash | ✅ |
| 100031 | 15 | T1003.006 DCSync | ✅ 53x |

---

## Root Cause Analysis

| Vulnerability | Impact |
|---|---|
| LLMNR enabled by default | Initial credential theft |
| Weak service account password | Kerberoasting success |
| NTLM authentication enabled | Pass-the-Hash possible |
| WriteDACL misconfiguration on domain object | Full domain compromise |
| No privileged account monitoring | Late detection |

---

## Immediate Response Actions
```powershell
# 1. Disable compromised accounts
Disable-ADAccount -Identity svc-mssql
Disable-ADAccount -Identity testuser

# 2. Rotate krbtgt password (twice, 10 hours apart)
Set-ADAccountPassword -Identity krbtgt `
  -NewPassword (ConvertTo-SecureString "NewP@ssw0rd2026!" -AsPlainText -Force) `
  -Reset

# 3. Disable LLMNR via GPO
# Computer Configuration → Administrative Templates →
# Network → DNS Client → Turn off multicast name resolution → Enabled
```

---

## Recommendations

| Priority | Action |
|---|---|
| CRITICAL | Disable LLMNR and NBT-NS domain-wide |
| CRITICAL | Remove WriteDACL from all service accounts |
| CRITICAL | Rotate krbtgt password immediately |
| HIGH | Enforce AES-only Kerberos — disable RC4 |
| HIGH | Implement LAPS for local admin accounts |
| HIGH | Deploy Protected Users Security Group |
| HIGH | Disable NTLM authentication domain-wide |
| MEDIUM | Regular BloodHound ACL audits |
| MEDIUM | Implement tiered administration model |

---

## Lessons Learned

1. **Default configurations are dangerous** — LLMNR enabled by default
   led directly to credential theft.

2. **Service accounts need strong passwords** — RC4 encryption
   made Kerberoasting trivial.

3. **ACL misconfigurations are critical** — A single WriteDACL
   on the domain object led to full compromise.

4. **Detection works** — Wazuh detected every phase with
   custom rules mapped to MITRE ATT&CK.

5. **Active Response needs careful design** — firewall-drop
   is not always the right response (e.g., DCSync).