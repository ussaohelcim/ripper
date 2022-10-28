param(
	[string]$version,
	[switch]$build,
	$source = "src"
)

$path = "$PSScriptRoot/$source/pdxinfo"
$pdxinfo = Get-Content $path

$pdxinfo = $pdxinfo.Split("\n")
$output = ""

if("" -eq $version){
	foreach($line in $pdxinfo){

		if($line.StartsWith("buildNumber")){
			Write-Host $line
		}
		elseif($line.StartsWith("version")){
			Write-Host $line
		} 

	}
}
else{

	foreach($line in $pdxinfo){
		#buildNumber=123
		$l = ""
	
		if($line.StartsWith("buildNumber")){
			$v = $version.Replace('.','')
			$l = "buildNumber=" + $v + "`n"
		}
		elseif($line.StartsWith("version")){
			$l = "version=" + $version + "`n"
		} else{
			$l = $line + "`n"
		}
	
		if($l -ne "`n"){
			$output += $l #+ "`n"
		}
	}

	Set-Content $path $output
	Write-Host "Updated pdxfinfo" -ForegroundColor Green
	Write-Host $output
}

if($build){
	.\build.ps1
}