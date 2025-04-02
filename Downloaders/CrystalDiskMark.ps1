param (
    [string]$BasePath = $PSScriptRoot # fallback if run manually
)

# CrystalDiskMark
$downloadUrl = "https://downloads.sourceforge.net/project/crystaldiskmark/8.0.6/CrystalDiskMark8_0_6.zip?ts=gAAAAABn7H4eY37AGADC3lPRw_z_4s1mAMAmeZdgpyBAoMoQN7q0hRmFBjx5AiZsuFlgo36BTiSCslgaSIsJADu_TboXjO9DZQ%3D%3D&r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fcrystaldiskmark%2Ffiles%2F8.0.6%2FCrystalDiskMark8_0_6.zip%2Fdownload"
$targetDir = "$BasePath\Tools\Windows\CrystalDiskMark"
$workingDir = "$BasePath\Tools\Temp"
$tempZip = "$workingDir\crystaldiskmark.zip"
$tempExtract = "$workingDir\extract"

# Clean up working directory
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue $workingDir
New-Item -ItemType Directory -Force -Path $workingDir | Out-Null

# Download ZIP using curl (handles SourceForge redirect)
Start-Process -FilePath "curl.exe" -ArgumentList @("-L", "`"$downloadUrl`"", "-o", "`"$tempZip`"") -NoNewWindow -Wait

# Extract ZIP
Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force

# Create target directory
New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

# Move extracted contents into the target directory
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

# Clean up
Remove-Item -Recurse -Force $workingDir

Write-Host "✅ CrystalDiskMark extracted to: $targetDir"
