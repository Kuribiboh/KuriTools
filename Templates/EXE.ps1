param (
	[string]$BasePath = $PSScriptRoot # fallback if run manually
)

# "App Name"
$downloadUrl = "Download URL"
$targetDir = "$BasePath\Tools\Windows\App Name"
$exeName = "App Name.exe"
$tempExe = "$BasePath\Tools\Temp\$exeName"

# Ensure working and target directories exist
New-Item -ItemType Directory -Force -Path "$BasePath\Tools\Temp" | Out-Null
New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

# Download the EXE file
Invoke-WebRequest -Uri $downloadUrl -OutFile $tempExe

# Move the EXE to the target directory
Move-Item -Path $tempExe -Destination "$targetDir\$exeName" -Force

Write-Host "App Name downloaded to: $targetDir\$exeName"