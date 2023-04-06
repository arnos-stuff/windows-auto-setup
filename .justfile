set shell := ["powershell.exe", "-c"]

alias b := build

setup:
	$PKG = "Go"
	Write-Host "❓ Checking if $PKG installed" -ForegroundColor Yellow
	if ($(Get-Command Go -ErrorAction SilentlyContinue).Length -gt 0) { scoop install go }
	Write-Host "✅ Done with $PKG" -ForegroundColor Green
	$PKG = "MSVC C++"
	Invoke-WebRequest -Uri 'https://aka.ms/vs/17/release/vs_BuildTools.exe' -OutFile "$env:TEMP\vs_BuildTools.exe"
	& "$env:TEMP\vs_BuildTools.exe" --force --quiet --wait --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended --remove Microsoft.VisualStudio.Component.VC.CMake.Project
	$startTime = $(Get-Date).Ticks
	While ($(ps | sls vs_BuildTools).Length -gt 0) {
		$currTime = $startTime = $(Get-Date).Ticks
		$elapsed = $currTime - $startTime
		Write-
	}
buildrym:
	
