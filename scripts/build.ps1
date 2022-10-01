$file = Get-Content (Join-Path ($PSScriptRoot) ".." ("src","pdxinfo"))

$gameName = ($file | Select-String -Pattern 'bundleID=').ToString().replace("bundleID=","").Replace("com.NILCO.","")  #"ripper" #(get-content .\src\pdxinfo | Select-String -Pattern 'bundleID=')

#(?<=bundleID=)(.*?)(?=\n)
$version = ($file | Select-String -Pattern 'buildNumber=').ToString().replace("buildNumber=","")  #"100" #(get-content .\src\pdxinfo | Select-String -Pattern 'buildNumber=')
#(?<=buildNumber=)(.*?)(?=\n)
$fileName = "$gameName-$version"
$dist = (Join-Path ($PSScriptRoot) ".." ($fileName))
$src = (Join-Path ($PSScriptRoot) ".." ("src"))

& pdc $src $dist
& 7z a -tzip  "$fileName.pdx.zip" "$fileName.pdx"
