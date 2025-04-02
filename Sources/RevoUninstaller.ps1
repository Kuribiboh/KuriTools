param (
	[string]$BasePath = $PSScriptRoot # fallback if run manually
)

# Revo Uninstaller
$downloadUrl = "https://f3b1cfc5d488c0384dc3-056ccca39cd416ca6db85fa26f78b9ef.ssl.cf1.rackcdn.com/RevoUninstaller_Portable.zip"
$targetDir = "$BasePath\Tools\Windows\RevoUninstaller"
$workingDir = "$BasePath\Tools\Temp"
$tempZip = "$workingDir\revo.zip"
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

Write-Host "Revo Uninstaller extracted to: $targetDir"