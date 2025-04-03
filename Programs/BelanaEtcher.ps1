param (
    [string]$BasePath = $PSScriptRoot # fallback if run manually
)

# balenaEtcher
$apiUrl = "https://api.github.com/repos/balena-io/etcher/releases/latest"
$targetDir = "$BasePath\Tools\Windows\BalenaEtcher"
$workingDir = "$BasePath\Tools\Temp"
$tempExe = "$workingDir\balenaetcher-setup-temp.exe"
$finalExe = "$targetDir\BalenaEtcher.exe"

# Ensure working and target directories exist
New-Item -ItemType Directory -Force -Path $workingDir | Out-Null
New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

# Get latest release info and locate the Windows Setup EXE
try {
    $releaseInfo = Invoke-RestMethod -Uri $apiUrl -Headers @{ "User-Agent" = "PowerShell" }
    $asset = $releaseInfo.assets | Where-Object { $_.name -like "*Setup.exe" } | Select-Object -First 1
    if (-not $asset) {
        Write-Host "❌ No Windows setup executable found in latest release."
        exit
    }
    $downloadUrl = $asset.browser_download_url
} catch {
    Write-Host "❌ Failed to retrieve balenaEtcher release info from GitHub."
    exit
}

# Download EXE
try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $tempExe
    Write-Host "✅ Downloaded balenaEtcher setup from: $downloadUrl"
} catch {
    Write-Host "❌ Failed to download balenaEtcher EXE."
    exit
}

# Move and rename to final destination
Move-Item -Path $tempExe -Destination $finalExe -Force

Write-Host "✅ balenaEtcher saved as: $finalExe"