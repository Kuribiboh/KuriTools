param (
    [string]$BasePath = $PSScriptRoot # fallback if run manually
)

# FurMark
$downloadUrl = "https://geeks3d.com/dl/get/794"
$targetDir = "$BasePath\Tools\Windows\FurMark"
$workingDir = "$BasePath\Tools\Temp"
$tempZip = "$workingDir\furmark.zip"
$tempExtract = "$workingDir\extract"

# Clean up old working directory
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue $workingDir
New-Item -ItemType Directory -Force -Path $workingDir | Out-Null

# Ensure target directory exists
New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

# Download ZIP (with redirection)
Invoke-WebRequest -Uri $downloadUrl -OutFile $tempZip -MaximumRedirection 5

# Extract ZIP
Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force

# Create target dir
New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

# Try to find a subfolder inside the extracted folder
$innerFolder = Get-ChildItem -Path $tempExtract | Where-Object { $_.PSIsContainer } | Select-Object -First 1

if ($innerFolder) {
    Move-Item -Path "$($innerFolder.FullName)\*" -Destination $targetDir -Force
} else {
    # No subfolder — move everything directly
    Move-Item -Path "$tempExtract\*" -Destination $targetDir -Force
}

# Clean up
Remove-Item -Recurse -Force $workingDir
# Clean up temp files
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue $workingDir

Write-Host "✅ FurMark portable extracted to: $targetDir"
