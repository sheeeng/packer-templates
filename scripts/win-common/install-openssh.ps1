#!/usr/bin/env powershell

$ErrorActionPreference = "Stop" # Fail fast!

# Fix Invoke-WebRequest failure that could not create SSL/TLS secure channel.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$OPENSSH_WIN64 = "OpenSSH-Win64"
$URL = "https://github.com/PowerShell/Win32-OpenSSH/releases/download/v7.7.2.0p1-Beta/$OPENSSH_WIN64.zip"

$OPENSSH = "OpenSSH"
Invoke-WebRequest -Uri $URL -OutFile "$OPENSSH.zip" -Verbose
# Expand-Archive "$OPENSSH.zip" -DestinationPath "/var/" -Verbose
$PROGRAMFILES = "C:\Program Files\"
Expand-Archive "$OPENSSH.zip" -DestinationPath $PROGRAMFILES
Remove-Item "$OPENSSH.zip" -Verbose

Rename-Item -Path "$PROGRAMFILES\$OPENSSH_WIN64" -NewName "$OPENSSH" -Verbose

Write-Output "Setting vagrant user file permissions...."
$VAGRANTHOME = "C:\Users\vagrant"
New-Item -ItemType Directory -Force -Path "$VAGRANTHOME\.ssh" -Verbose
C:\Windows\System32\icacls.exe "$VAGRANTHOME" /grant "vagrant:(OI)(CI)F"
C:\Windows\System32\icacls.exe "$PROGRAMFILES\$OPENSSH" /grant "vagrant:(OI)RX"

Set-Location -Path "$PROGRAMFILES\$OPENSSH" -Verbose
powershell.exe -ExecutionPolicy Bypass -File install-sshd.ps1

Write-Output "Configuring Firewall...."
New-NetFirewallRule -Name sshd `
    -Action Allow `
    -Direction Inbound `
    -DisplayName 'OpenSSH Server Daemon (sshd)' `
    -Enabled True `
    -LocalPort 22 `
    -Protocol TCP `
    -Verbose

Set-Service sshd -StartupType Automatic -Verbose
Start-Service sshd -Verbose
