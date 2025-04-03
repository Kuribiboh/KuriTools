param (
    [string]$BasePath = $PSScriptRoot # fallback if run manually
)

# Junkware Removal Tool (JRT)
$downloadUrl = "https://www.bleepingcomputer.com/download/junkware-removal-tool/dl/293/"
$targetDir = "$BasePath\Tools\Windows\JRT"
$workingDir = "$BasePath\Tools\Temp"
$exeName = "jrt.exe"
$tempExe = "$workingDir\$exeName"

# Ensure working and target directories exist
New-Item -ItemType Directory -Force -Path $workingDir | Out-Null
New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

# Download the EXE
Invoke-WebRequest -Uri $downloadUrl -OutFile $tempExe

# Move to target location
Move-Item -Path $tempExe -Destination "$targetDir\$exeName" -Force

Write-Host "JRT downloaded to: $targetDir\$exeName"
