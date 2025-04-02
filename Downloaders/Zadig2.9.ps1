param (
	[string]$BasePath = $PSScriptRoot # fallback if run manually
)

# Zadig
$downloadUrl = "https://github.com/pbatard/libwdi/releases/download/v1.5.1/zadig-2.9.exe"
$targetDir = "$BasePath\Tools\Windows\Zadig"
$workingDir = "$BasePath\Tools\Temp"
$exeName = "Zadig.exe"
$tempExe = "$workingDir\$exeName"

# Ensure working and target directories exist
New-Item -ItemType Directory -Force -Path $workingDir | Out-Null
New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

# Download the EXE
Invoke-WebRequest -Uri $downloadUrl -OutFile $tempExe

# Move to target location
Move-Item -Path $tempExe -Destination "$targetDir\$exeName" -Force

Write-Host "Zadig downloaded to: $targetDir\$exeName"