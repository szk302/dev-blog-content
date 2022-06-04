$INSTALLER_FILE_NAME = "vscode_installer.exe";
$INSTALLER_VERSION = "latest";
$current_dir_path = $PSScriptRoot;
$tmp_dir_path = "$env:TEMP/" + (Get-Date).ToString("yyyyMMdd_HHmmssfff");
$installer_file_path = "${tmp_dir_path}/${INSTALLER_FILE_NAME}"
New-Item -ItemType Directory ${tmp_dir_path};
Invoke-WebRequest "https://update.code.visualstudio.com/${INSTALLER_VERSION}/win32-x64/stable" -OutFile ${installer_file_path};
Start-Process -FilePath ${installer_file_path} -Args "/VERYSILENT /NORESTART /MERGETASKS=!runcode,desktopicon,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath /LOG=${current_dir_path}/vscode_installer.log" -Verb RunAs -Wait;
Remove-Item ${tmp_dir_path} -Recurse -Force