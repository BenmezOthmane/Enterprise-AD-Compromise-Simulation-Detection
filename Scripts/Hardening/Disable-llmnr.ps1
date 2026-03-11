# Disable-llmnr.ps1
# Disables LLMNR and NBT-NS to prevent poisoning attacks

Write-Host "[*] Disabling LLMNR..." -ForegroundColor Yellow

# Disable LLMNR via Registry
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient"
If (!(Test-Path $regPath)) {
    New-Item -Path $regPath -Force
}
Set-ItemProperty -Path $regPath -Name "EnableMulticast" -Value 0
Write-Host "[+] LLMNR disabled" -ForegroundColor Green

# Disable NBT-NS
Write-Host "[*] Disabling NBT-NS..." -ForegroundColor Yellow
$regKey = "HKLM:SYSTEM\CurrentControlSet\services\NetBT\Parameters\Interfaces"
Get-ChildItem $regKey | ForEach-Object {
    Set-ItemProperty -Path "$regKey\$($_.PSChildName)" `
        -Name NetbiosOptions -Value 2
}
Write-Host "[+] NBT-NS disabled" -ForegroundColor Green

# Enable SMB Signing
Write-Host "[*] Enabling SMB Signing..." -ForegroundColor Yellow
Set-SmbServerConfiguration -RequireSecuritySignature $true -Force
Set-SmbClientConfiguration -RequireSecuritySignature $true -Force
Write-Host "[+] SMB Signing enabled" -ForegroundColor Green

Write-Host "[+] Hardening complete!" -ForegroundColor Green
