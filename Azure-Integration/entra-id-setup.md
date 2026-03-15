# Azure Entra ID (Azure AD) Setup

## Overview
Azure Entra ID used for identity and access management 
of the Azure SOC Lab environment.

## Configuration
| Setting | Value |
|---|---|
| Tenant | Default Directory |
| Domain | othmanebenmezgmail.onmicrosoft.com |
| Subscription | Azure subscription 1 |
| Account type | Personal (Free Trial) |

## App Registration for Wazuh
Service principal created to allow Wazuh to authenticate 
to Azure Log Analytics without using personal credentials.

| Field | Value |
|---|---|
| App name | wazuh-sentinel-app |
| Authentication | Client credentials (secret) |
| Permission model | Application permissions |

## Security Notes
- Client secret rotated and stored securely
- Principle of least privilege applied
- Log Analytics Reader role only — no write access