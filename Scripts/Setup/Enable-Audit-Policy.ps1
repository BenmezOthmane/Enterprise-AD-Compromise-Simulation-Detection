<#
.SYNOPSIS
    Configures advanced Windows audit policies on DC01 for AD attack detection.

.DESCRIPTION
    These audit policies were applied manually via Group Policy Management Console (GPMC) on DC01.
    Path: Default Domain Controllers Policy > Computer Configuration >
          Windows Settings > Security Settings >
          Advanced Audit Policy Configuration > Audit Policies

    Each policy is mapped to a specific Windows Event ID that Wazuh uses
    to detect the attack techniques simulated in this project.

    Apply Method : Group Policy (GPO) — configured manually via GPMC.
                   Note: On Domain Controllers, GPO overrides local auditpol,
                   which is why GPMC was used instead of auditpol commands.

.NOTES
    Author      : Othmane Benmezian
    DC          : DC01 — SOC.local (Windows Server 2022)
    Date        : 2026-03-02
#>

# ─────────────────────────────────────────────
#  ACCOUNT LOGON
#  Detects Kerberos-based attacks (Kerberoasting)
#  Applied via GPMC: Audit Policies > Account Logon
# ─────────────────────────────────────────────
#  [CONFIGURED] Audit Kerberos Service Ticket Operations → Success & Failure
#               Event ID 4769 — TGS ticket requested (key indicator for Kerberoasting)
#               MITRE: T1558.003
#
#  [CONFIGURED] Audit Kerberos Authentication Service → Success & Failure
#               Event ID 4768 — TGT ticket requested
#               MITRE: T1558.003
#
#  [CONFIGURED] Audit Credential Validation → Success & Failure
#               Event ID 4776 — NTLM credential validation attempt
#               MITRE: T1557.001

# ─────────────────────────────────────────────
#  ACCOUNT MANAGEMENT
#  Detects privilege escalation via group changes
#  Applied via GPMC: Audit Policies > Account Management
# ─────────────────────────────────────────────
#  [CONFIGURED] Audit Security Group Management → Success & Failure
#               Event ID 4728 — Member added to privileged security group
#               MITRE: T1078.002
#
#  [CONFIGURED] Audit User Account Management → Success & Failure
#               Event ID 4720 — New user account created
#               MITRE: T1078.002

# ─────────────────────────────────────────────
#  DS ACCESS
#  Detects DCSync and directory enumeration
#  Applied via GPMC: Audit Policies > DS Access
# ─────────────────────────────────────────────
#  [CONFIGURED] Audit Directory Service Access → Success & Failure
#               Event ID 4662 — AD object accessed (DCSync replication trigger)
#               MITRE: T1078.002
#
#  [CONFIGURED] Audit Directory Service Changes → Success & Failure
#               Event ID 5136 — AD object attribute modified
#               MITRE: T1078.002

# ─────────────────────────────────────────────
#  PRIVILEGE USE
#  Detects high-value privilege assignment
#  Applied via GPMC: Audit Policies > Privilege Use
# ─────────────────────────────────────────────
#  [CONFIGURED] Audit Sensitive Privilege Use → Success & Failure
#               Event ID 4672 — SeDebugPrivilege or similar assigned at logon
#               MITRE: T1078.002

# ─────────────────────────────────────────────
#  LOGON / LOGOFF
#  Detects Pass-the-Hash and unusual logon types
#  Applied via GPMC: Audit Policies > Logon/Logoff
# ─────────────────────────────────────────────
#  [CONFIGURED] Audit Special Logon → Success & Failure
#               Event ID 4964 — Special groups assigned to new logon
#               MITRE: T1550.002

# ─────────────────────────────────────────────
#  Apply GPO changes immediately
# ─────────────────────────────────────────────
gpupdate /force
