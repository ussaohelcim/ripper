$file = Get-Content (Join-Path ($PSScriptRoot) ".." ("src","pdxinfo"))

$gameName = "ripper"
#(?<=bundleID=)(.*?)(?=\n)
$version = "100"
#(?<=buildNumber=)(.*?)(?=\n)
$dist = (Join-Path ($PSScriptRoot) ".." ("$gameName-$version"))
$src = (Join-Path ($PSScriptRoot) ".." ("src"))
& pdc $src $dist

# Write-Host ($file -match '(?<=bundleID=)(.*?)(?=\n)')[0]