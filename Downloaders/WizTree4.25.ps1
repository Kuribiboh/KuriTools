param (
    [string]$BasePath = $PSScriptRoot # fallback if run manually
)

# WizTree
$downloadUrl = "https://diskanalyzer.com/files/wiztree_4_25_portable.zip"
$targetDir = "$BasePath\Tools\Windows\WizTree"
$workingDir = "$BasePath\Tools\Temp"
$tempZip = "$workingDir\WizTree.zip"
$tempExtract = "$workingDir\extract"

# Clean up working directory
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue $workingDir
New-Item -ItemType Directory -Force -Path $workingDir | Out-Null

# Download and extract
Invoke-WebRequest -Uri $downloadUrl -OutFile $tempZip
Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force

# Create target dir
New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

# Move extracted files into target
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

Write-Host "✅ WizTree extracted to: $targetDir"