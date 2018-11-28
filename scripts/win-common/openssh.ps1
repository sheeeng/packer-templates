$is_64bit = [IntPtr]::size -eq 8

# setup openssh
$ssh_download_url = "https://github.com/PowerShell/Win32-OpenSSH/releases/download/v7.7.2.0p1-Beta/OpenSSH-Win64.zip"

Stop-Service "OpenSSHd" -Force

Expand-Archive "OpenSSH-Win64.zip" -DestinationPath "C:\Program Files\OpenSSH\"

Write-Output "Setting vagrant user file permissions...."
New-Item -ItemType Directory -Force -Path "C:\Users\vagrant\.ssh"
C:\Windows\System32\icacls.exe "C:\Users\vagrant" /grant "vagrant:(OI)(CI)F"
C:\Windows\System32\icacls.exe "C:\Program Files\OpenSSH\" /grant "vagrant:(OI)RX"

Set-Location -Path "C:\Program Files\OpenSSH"
powershell.exe -ExecutionPolicy Bypass -File install-sshd.ps1

Write-Output "Configuring Firewall...."
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server Daemon (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22

Set-Service sshd -StartupType Automatic

Start-Service sshd
