
# Azure Sentinel Integration

## Overview
Microsoft Sentinel configured as cloud SIEM to receive 
Wazuh alerts for centralized threat monitoring and correlation.

## Architecture
```
Wazuh Manager (Docker/Ubuntu)
        ↓
wazuh-integratord
        ↓
Azure Log Analytics Workspace (RG-SOC-Lab)
        ↓
Microsoft Sentinel — Cloud SIEM
```

## Azure Components Created
| Component | Name | Details |
|---|---|---|
| Resource Group | RG-SOC-Lab | West Europe |
| Log Analytics Workspace | RG-SOC-Lab | Free Trial — 10GB/day |
| Microsoft Sentinel | RG-SOC-Lab | Active until 15 Apr 2026 |
| App Registration | wazuh-sentinel-app | Single tenant |

## App Registration Details
| Field | Value |
|---|---|
| Display name | wazuh-sentinel-app |
| API Permission | Log Analytics API — Data.Read |
| IAM Role | Log Analytics Data Reader |
| Client Secret | Configured (expires 3/15/2027) |

## Wazuh Integration Configuration
```xml
<integration>
  <name>sentinel</name>
  <hook_url>https://WORKSPACE_ID.ods.opinsights.azure.com/api/logs?api-version=2016-04-01</hook_url>
  <api_key>PRIMARY_KEY</api_key>
  <alert_format>json</alert_format>
  <level>10</level>
</integration>
```

## Known Limitation
Wazuh 4.9 does not natively support Azure Sentinel 
as a built-in integration name.

Full log forwarding requires Logstash pipeline:
```
Wazuh → Filebeat → Logstash → Azure Sentinel
```

## Evidence
| File | Description |
|---|---|
| `Evidence/Screenshots/sentinel-dashboard.png` | Sentinel Dashboard |
| `Evidence/Screenshots/azure-app-registration.png` | App Registration |
| `Evidence/Screenshots/azure-api-permissions.png` | API Permissions granted |
| `Evidence/Screenshots/azure-client-secret.png` | Client Secret configured |