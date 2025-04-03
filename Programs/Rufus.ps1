param (
    [string]$BasePath = $PSScriptRoot # fallback if run manually
)

# Rufus
$apiUrl = "https://api.github.com/repos/pbatard/rufus/releases/latest"
$targetDir = "$BasePath\Tools\Windows\Rufus"
$workingDir = "$BasePath\Tools\Temp"
$exeName = "rufus-latest.exe"
$tempExe = "$workingDir\$exeName"

# Ensure working and target directories exist
New-Item -ItemType Directory -Force -Path $workingDir | Out-Null
New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

# Get latest release version via GitHub API
try {
    $releaseInfo = Invoke-RestMethod -Uri $apiUrl -Headers @{ "User-Agent" = "PowerShell" }
    $latestTag = $releaseInfo.tag_name  # e.g., "v4.6"
    $version = $latestTag.TrimStart("v")
    $downloadUrl = "https://github.com/pbatard/rufus/releases/download/$latestTag/rufus-${version}p.exe"
} catch {
    Write-Host "❌ Failed to retrieve Rufus release info from GitHub."
    exit
}

# Download the EXE
try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $tempExe
    Write-Host "✅ Rufus downloaded from: $downloadUrl"
} catch {
    Write-Host "❌ Failed to download Rufus EXE."
    exit
}

# Move to target location
Move-Item -Path $tempExe -Destination "$targetDir\$exeName" -Force

Write-Host "✅ Rufus portable saved to: $targetDir\$exeName"