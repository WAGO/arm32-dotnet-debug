In order to publish and remote debug your dotnet application you have to
add appropriate entries in the vscode user/workspace settings.

For example:
```
{
    "dotnetDebug.remoteHost": "root@192.168.0.55",
    "dotnetDebug.remoteFolder": "/home/dotnet"
}
```

You can open the user settings.json file with the Preferences: Open User/Workspace Settings (JSON) command in the Command Palette (Ctrl+Shift+P). 