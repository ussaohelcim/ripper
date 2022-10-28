param(
	[switch]$run,
	$source = "src", 
	$destination = "dist",
	$company = "NILCO"
)

$file = Get-Content "$PSScriptRoot/src/pdxinfo" #(Join-Path ("src","pdxinfo"))

$gameName = ($file | Select-String -Pattern 'bundleID=').ToString().replace("bundleID=","").Replace("com.$company.","")  

$build = ($file | Select-String -Pattern 'buildNumber=').ToString().replace("buildNumber=","")
$fileName = "$gameName-$build"

$dist = "$PSScriptRoot/$destination/$fileName" 
$src = "$PSScriptRoot/$source"

Write-Host "Compiling $src into $dist" -ForegroundColor Green

& pdc $src $dist

Write-Host "Compressing $dist.pdx into $dist.pdx.zip" -ForegroundColor Green

& 7z a -tzip  "$dist.pdx.zip" "$dist.pdx"

Write-Host "'$gameName' build '$build' compiled at: $dist" -ForegroundColor Green

if($run){

	$simulator = Get-Process "PlaydateSimulator" -ErrorAction SilentlyContinue

	if ($simulator) {
		Write-Host "Closing simulator..." -ForegroundColor Green
		$simulator | Stop-Process -Force
	}

	Write-Host "Starting game on simulator" "$dist.pdx"-ForegroundColor Green

	& PlaydateSimulator "$dist.pdx"
}
