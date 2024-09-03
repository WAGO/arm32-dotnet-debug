[CmdletBinding()]
param(
    [Parameter(Mandatory)][String]$csproj,
    [Parameter(Mandatory)][String]$remoteHost,
    [Parameter(Mandatory)][String]$remoteFolder
)

$localPublishFolder = "/workspace/publish"

dotnet publish $csproj --self-contained --runtime linux-arm --configuration debug --output $localPublishFolder
ssh -q $remoteHost rm -r $remoteFolder/*
scp -q -r $localPublishFolder/* ($remoteHost + ":$remoteFolder")