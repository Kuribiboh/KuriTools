param (
    [string]$BasePath = $PSScriptRoot # fallback if run manually
)

# Download and extract from Google Drive
$downloadUrl = "https://drive.google.com/uc?export=download&id=1g8LfnYL54Q7S3vukRa_x-cMRNV8MQxPm"
$targetDir = "$BasePath\Tools\Windows"
$workingDir = "$BasePath\Tools\Temp"
$tempZip = "$workingDir\wiztree.zip"
$tempExtract = "$workingDir\extract"

# Ensure working directories
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue $workingDir
New-Item -ItemType Directory -Force -Path $tempExtract | Out-Null
New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

# Download the ZIP
Invoke-WebRequest -Uri $downloadUrl -OutFile $tempZip

# Extract ZIP to temp
Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force

# Move inner contents of 'scripts/' to Tools\Windows
$innerFolder = Get-ChildItem -Path $tempExtract | Where-Object { $_.PSIsContainer -and $_.Name -eq "scripts" } | Select-Object -First 1

if ($innerFolder) {
    Move-Item -Path "$($innerFolder.FullName)\*" -Destination $targetDir -Force
    Write-Host "Extracted contents moved to: $targetDir"
} else {
    Write-Host "⚠️ Could not find 'scripts' folder in ZIP. Nothing moved."
}

# Clean
