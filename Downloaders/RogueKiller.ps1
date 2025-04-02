param (
    [string]$BasePath = $PSScriptRoot # Fallback if run manually
)

# RogueKiller
$downloadUrl = "https://download.adlice.com/api?action=download&app=roguekiller&type=setup"
$targetDir = "$BasePath\Tools\Windows\RogueKiller"
$workingDir = "$BasePath\Tools\Temp"
$exeName = "RogueKiller_setup.exe"
$tempExe = "$workingDir\$exeName"

# Ensure working and target directories exist
New-Item -ItemType Directory -Force -Path $workingDir | Out-Null
New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

# Download the EXE
Invoke-WebRequest -Uri $downloadUrl -OutFile $tempExe

# Move to target location
Move-Item -Path $tempExe -Destination "$targetDir\$exeName" -Force

Write-Host "RogueKiller setup downloaded to: $targetDir\$exeName"
