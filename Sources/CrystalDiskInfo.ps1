param (
    [string]$BasePath = $PSScriptRoot # fallback if run manually
)

# CrystalDiskInfo ZIP - redirected download with query string
$downloadUrl = "https://downloads.sourceforge.net/project/crystaldiskinfo/9.6.3/CrystalDiskInfo9_6_3.zip?ts=gAAAAABn7H191gycEgTGHWtS2wuxa_g7Iqo0d4sL327FNVsEBlTZCGUq5L-E63-X0oVHJzi2f2k3JDsqzVJT8htuUbLaICzz_w%3D%3D&r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fcrystaldiskinfo%2Ffiles%2F9.6.3%2FCrystalDiskInfo9_6_3.zip%2Fdownload"
$targetDir = "$BasePath\Tools\Windows\CrystalDiskInfo"
$workingDir = "$BasePath\Tools\Temp"
$tempZip = "$workingDir\crystaldiskinfo.zip"
$tempExtract = "$workingDir\extract"

# Clean up any previous run
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue $workingDir
New-Item -ItemType Directory -Force -Path $workingDir | Out-Null

# Use curl to properly follow redirects and download the ZIP
Start-Process -FilePath "curl.exe" -ArgumentList @("-L", "`"$downloadUrl`"", "-o", "`"$tempZip`"") -NoNewWindow -Wait

# Extract the ZIP
Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force

# Create the target directory
New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

# Move everything from the extracted folder to the target
Get-ChildItem -Path $tempExtract -Recurse | ForEach-Object {
    $sourcePath = $_.FullName
    $relativePath = $sourcePath.Substring($tempExtract.Length).TrimStart("\")
    $destinationPath = Join-Path $targetDir $relativePath

    if ($_.PSIsContainer) {
        New-Item -ItemType Directory -Force -Path $destinationPath | Out-Null
    } else {
        $destDir = Split-Path -Parent $destinationPath
        New-Item -ItemType Directory -Force -Path $destDir | Out-Null
        Move-Item -Path $sourcePath -Destination $destinationPath -Force
    }
}

# Clean up temp folder
Remove-Item -Recurse -Force $workingDir

Write-Host "✅ CrystalDiskInfo fully extracted to: $targetDir"
