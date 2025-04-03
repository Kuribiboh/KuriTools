param (
	[string]$BasePath = $PSScriptRoot # fallback if run manually
)

# RKill
$downloadUrl = "https://www.bleepingcomputer.com/download/rkill/dl/10/"
$targetDir = "$BasePath\Tools\Windows\RKill"
$workingDir = "$BasePath\Tools\Temp"
$exeName = "rkill.exe"
$tempExe = "$workingDir\$exeName"

# Ensure working and target directories exist
New-Item -ItemType Directory -Force -Path $workingDir | Out-Null
New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

# Download the EXE
Invoke-WebRequest -Uri $downloadUrl -OutFile $tempExe

# Move to target location
Move-Item -Path $tempExe -Destination "$targetDir\$exeName" -Force

Write-Host "RKill downloaded to: $targetDir\$exeName"