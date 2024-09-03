[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [String]$remote
)
$folder = ".vs-debugger"
$getVsDbg = $folder + "/GetVsDbg.sh"

if (Test-Path($folder)) {
    Remove-Item $folder/* -Recurse -Force
}
else {
    mkdir $folder
}
Invoke-WebRequest -Uri https://aka.ms/getvsdbgsh -OutFile .vs-debugger/GetVsDbg.sh

$version = (Select-String -Path $getVsDbg -Pattern "(?<=__VsDbgVersion=).+").Matches[0].Value
$zipFile = "/vsdbg-linux-arm.zip"
$uri = "https://vsdebugger.azureedge.net/vsdbg-" + $version.Replace('.', '-') + $zipFile
$vsName = "vs2022"

Invoke-WebRequest -Uri $uri -OutFile ($folder + "/" + $zipFile)
Expand-Archive -Path (Join-Path $folder $zipFile) -DestinationPath (Join-Path $folder $vsName)
Remove-Item -Path (Join-Path $folder $zipFile)

Rename-Item -Path (Join-Path $folder $vsName "vsdbg") -NewName "vsdbg2"
"export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true
export COMPlus_LTTng=0
~/.vs-debugger/" + $vsName + "/vsdbg2"
| Out-File -Path (Join-Path $folder $vsName "vsdbg") -NoNewline

$version | Out-File -Path (Join-Path $folder $vsName "success.txt") -NoNewline

scp -r $folder ($remote + ":~/")
ssh $remote ("chmod +x " + $folder + "/" + $vsName + "/" + "vsdbg2 " + $folder + "/" + $vsName + "/" + "vsdbg")  