# Backup Pipeline — SOC Lab

## Purpose
Automated VM snapshot script for SOC Lab environment.
Designed to capture clean-state snapshots post-incident remediation.

## Usage

**Pre-Attack (Recommended):**
```powershell
.\backup-vms.ps1 -SnapshotName "Pre-Attack" `
  -Description "Pre-Attack snapshot"
```

**Post-Incident (Current Use):**
```powershell
.\backup-vms.ps1 -SnapshotName "Post-Incident-Clean" `
  -Description "Post-Incident Clean State Snapshot"
```

## Note
In this simulation, snapshots were not captured pre-attack.
Script is provided as infrastructure automation reference
for production SOC environments.

## Requirements
- VMware vSphere PowerCLI
- PowerShell 5.1+
- VMware Workstation or ESXi
