Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
Invoke-WebRequest -Uri 'https://aka.ms/vs/17/release/vs_BuildTools.exe' -OutFile "$env:TEMP\vs_BuildTools.exe"
& "$env:TEMP\vs_BuildTools.exe" --force --quiet --wait --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended --remove Microsoft.VisualStudio.Component.VC.CMake.Project

function GetETA($startRefDate, $lengthSeconds) { 
    $Delta = $( $startRefDate.AddSeconds($lengthSeconds).Ticks - $(Get-Date).Ticks)
    return $(Get-Date $Delta -Format "HH:MM:ss")
} ;
function GetElapsed($startRefDate) { GetETA($startRefDate, 0) } ;

$RefDate = $(Get-Date) ;
$estimatedTime = 10*60 #10 mins ;
While ($(Get-Process | Select-String vs_BuildTools).Length -gt 0) {
    $Elapsed = GetElapsed $RefDate ;
    $ETA = GetETA $RefDate, $estimatedTime ;
    $fmtEstimated = Get-Date $(Get-Date 0).AddSeconds($estimatedTime).Ticks -Format "HH:MM:ss" ;
    $StatusDT = "Elapsed: $Elapsed | Estimated: $fmtEstimated | ETA: $ETA" ;
    
    Write-Progress -Activity "Downloading MSVC Build Tools" -PercentComplete -1 -CurrentOperation "$StatusDT"
}