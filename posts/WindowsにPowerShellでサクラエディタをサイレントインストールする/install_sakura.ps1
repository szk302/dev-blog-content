$INSTALLER_FILE_NAME = "sakura_installer.exe";
$INSTALLER_ZIP_FILE_NAME = "sakura_installer.zip"
$INSTALLER_URL = "https://github.com/sakura-editor/sakura/releases/download/v2.4.1/sakura-tag-v2.4.1-build2849-ee8234f-Win32-Release-Installer.zip"
$current_dir_path = $PSScriptRoot;
$tmp_dir_path = "$env:TEMP/" + (Get-Date).ToString("yyyyMMdd_HHmmssfff");
New-Item "${tmp_dir_path}" -ItemType Directory
Invoke-WebRequest "${INSTALLER_URL}" -OutFile ${tmp_dir_path}/${INSTALLER_ZIP_FILE_NAME};
Expand-Archive -Path ${tmp_dir_path}/${INSTALLER_ZIP_FILE_NAME} -DestinationPath ${tmp_dir_path};
Move-Item ${tmp_dir_path}/*.exe ${tmp_dir_path}/${INSTALLER_FILE_NAME}
Start-Process -FilePath ${tmp_dir_path}\${INSTALLER_FILE_NAME} -Args "/SP- /VERYSILENT /NORESTART /MERGETASKS=""desktopicon"" /LOG=${current_dir_path}/${INSTALLER_FILE_NAME}.log" -Verb RunAs -Wait;
Remove-Item "${tmp_dir_path}" -Recurse
