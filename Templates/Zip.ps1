param (
	[string]$BasePath = $PSScriptRoot # fallback if run manually
)

# App Name
$downloadUrl = "Download URL"
$targetDir = "$BasePath\Tools\Windows\HDSentinel"
$workingDir = "$BasePath\Tools\Temp"
$tempZip = "$workingDir\App Name.zip"
$tempExtract = "$workingDir\extract"

# Clean up working directory
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue $workingDir
New-Item -ItemType Directory -Force -Path $workingDir | Out-Null

# Download and extract
Invoke-WebRequest -Uri $downloadUrl -OutFile $tempZip
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

Write-Host "App Name extracted to: $targetDir"