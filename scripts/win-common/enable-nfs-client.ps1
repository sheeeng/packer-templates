#!/usr/bin/env powershell

$ErrorActionPreference = "Stop" # Fail fast!

Get-WindowsOptionalFeature -Online -Verbose | findstr /i nfs

Enable-WindowsOptionalFeature -Online -FeatureName "ServiceForNFS-ClientOnly" -All -Verbose
Enable-WindowsOptionalFeature -Online -FeatureName "NFS-Administration" -All -Verbose
Enable-WindowsOptionalFeature -Online -FeatureName "ClientForNFS-Infrastructure" -All -Verbose
