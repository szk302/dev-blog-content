$INSTALLER_FILE_NAME = "vscode_installer.exe";
$INSTALLER_VERSION = "latest";
$current_dir_path = $PSScriptRoot;
$path = $env:TEMP;
Invoke-WebRequest "https://update.code.visualstudio.com/${INSTALLER_VERSION}/win32-x64/stable" -OutFile ${path}\${INSTALLER_FILE_NAME};
Start-Process -FilePath ${path}\${INSTALLER_FILE_NAME} -Args "/VERYSILENT /NORESTART /MERGETASKS=!runcode,desktopicon,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath /LOG=${current_dir_path}/vscode_installer.log" -Verb RunAs -Wait;
Remove-Item $path\${INSTALLER_FILE_NAME};