param (
    [string]$BasePath = $PSScriptRoot # fallback if run manually
)

# GitHub API and paths
$apiUrl = "https://api.github.com/repos/Kuribiboh/KuriTools/releases/latest"
$workingDir = "$BasePath\Temp"
$tempZip = "$workingDir\KuriTools.zip"
$tempExtract = "$workingDir\extract"

# Clean old temp
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue $workingDir
New-Item -ItemType Directory -Force -Path $tempExtract | Out-Null

# GitHub headers
$headers = @{ "User-Agent" = "PowerShell" }

# Get ZIP URL from latest GitHub release
try {
    $release = Invoke-RestMethod -Uri $apiUrl -Headers $headers
    $zip = $release.assets | Where-Object { $_.name -like "*.zip" } | Select-Object -First 1
    if (-not $zip) { throw "No zip found in latest release." }
    $downloadUrl = $zip.browser_download_url
} catch {
    Write-Host "❌ Failed to fetch release info: $_"
    exit
}

# Download ZIP
Invoke-WebRequest -Uri $downloadUrl -OutFile $tempZip

# Extract
Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force

# Move files from inner folder to current directory
$innerFolder = Get-ChildItem $tempExtract | Where-Object { $_.PSIsContainer } | Select-Object -First 1
$extractedPaths = @()

if ($innerFolder) {
    Get-ChildItem -Path $innerFolder.FullName -Recurse | ForEach-Object {
        $source = $_.FullName
        $relative = $source.Substring($innerFolder.FullName.Length).TrimStart("\")
        $dest = Join-Path $BasePath $relative
        $extractedPaths += $dest

        if ($_.PSIsContainer) {
            New-Item -ItemType Directory -Force -Path $dest | Out-Null
        } else {
            $destDir = Split-Path $dest -Parent
            New-Item -ItemType Directory -Force -Path $destDir | Out-Null
            Move-Item -Path $source -Destination $dest -Force
        }
    }
} else {
    Write-Host "❌ No folder found inside archive."
    exit
}

# Clean up temp
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue $workingDir

# Run Update.bat
$updateBat = Join-Path $BasePath "Update.bat"
if (Test-Path $updateBat) {
    Write-Host "▶️ Running Update.bat..."
    Start-Process -FilePath $updateBat -Wait
    Write-Host "✅ Update.bat finished."
} else {
    Write-Host "⚠️ Update.bat not found."
}

# Clean up all extracted content (excluding this script)
Write-Host "🧹 Cleaning up extracted files..."

foreach ($path in $extractedPaths | Sort-Object -Descending) {
    try {
        if ((Test-Path $path) -and ($path -ne $MyInvocation.MyCommand.Path)) {
            Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
        }
    } catch {
        Write-Host "⚠️ Could not remove: $path"
    }
}

Write-Host "✅ All extracted files removed. KuriTools setup complete."