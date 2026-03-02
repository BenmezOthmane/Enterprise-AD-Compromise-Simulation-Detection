<#
.SYNOPSIS
    Downloads and installs Sysmon with SwiftOnSecurity hardened config.
.NOTES
    Author  : Othmane Benmezian
    Tested  : Windows 10 Pro / Windows Server 2022
    Version : Sysmon v15.15
#>

# Create installation directory
New-Item -ItemType Directory -Path "C:\Tools\Sysmon" -Force

# Download Sysmon from Sysinternals
Invoke-WebRequest -Uri "https://download.sysinternals.com/files/Sysmon.zip" `
    -OutFile "C:\Tools\Sysmon\Sysmon.zip"

# Extract the archive
Expand-Archive -Path "C:\Tools\Sysmon\Sysmon.zip" `
    -DestinationPath "C:\Tools\Sysmon" -Force

# Download SwiftOnSecurity hardened configuration
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/master/sysmonconfig-export.xml" `
    -OutFile "C:\Tools\Sysmon\sysmonconfig.xml"

# Install Sysmon with the hardened config
cd C:\Tools\Sysmon
.\Sysmon64.exe -accepteula -i sysmonconfig.xml

# Verify Sysmon service is running
Get-Service Sysmon64
