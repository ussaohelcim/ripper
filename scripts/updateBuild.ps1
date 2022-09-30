param([string]$version)

$pdxinfo = Get-Content (Join-Path ($PSScriptRoot) ".." ("src","pdxinfo"))

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

	Set-Content (Join-Path ($PSScriptRoot) ".." ("src","pdxinfo")) $output
	
	Write-Host $output
}