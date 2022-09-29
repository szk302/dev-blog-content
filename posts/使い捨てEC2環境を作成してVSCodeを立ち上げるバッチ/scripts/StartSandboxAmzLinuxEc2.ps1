$stackName="amz-ec2-$(Get-Date -Format yyyyMMddHHmmss)"
$instanceName="${stackName}"
$sshConfigDirPath="${Home}/.ssh/conf.d/ephemeral/${stackName}"
$sshConfigFilePath="${sshConfigDirPath}/${instanceName}.conf"
$keyFileName="${instanceName}.pem"
$keyFilePath="${sshConfigDirPath}/${keyFileName}"
$remoteHomeDirPath="/home/ec2-user"
$deleteBatFilePath="Delete-${stackName}.bat"

echo "###########################################"
echo "# StackName: ${stackName}"
echo "# InstanceName: ${instanceName}"
echo "# KeyFileName: ${keyFileName}"
echo "# KeyFilePath: ${keyFilePath}"
echo "# SshConfigFilePath: ${sshConfigFilePath}"
echo "###########################################"

## SSHConfigディレクトリの作成
mkdir "${sshConfigDirPath}" > $null

## リソースの作成
aws cloudformation deploy --template-file ./amz-ec2.yml --stack-name "${stackName}" --capabilities CAPABILITY_NAMED_IAM
## リソース作成待ち
aws cloudformation wait stack-create-complete --stack-name "${stackName}"
## インスタンスIDの取得
$instanceId = (aws cloudformation describe-stacks --stack-name "${stackName}" --query "Stacks[0].Outputs[?OutputKey==``Ec2InstanceId``].OutputValue" --output text).trim()
echo "instanceId:${instanceId}"
## EC2起動まち
aws ec2 wait instance-status-ok --include-all-instances --instance-ids "${instanceId}"
## キーペア取得
### キーペア名を取得
$keyPairName = (aws cloudformation describe-stacks --stack-name "${stackName}" --query "Stacks[0].Outputs[?OutputKey==``KeyPairPath``].OutputValue" --output text).trim()
echo "keyPairName:${keyPairName}"
### キーペアを取得
aws ssm get-parameter --name "${keyPairName}" --with-decryption --query "Parameter.Value" --output text | Set-Content -Path "${keyFilePath}"

## SSH設定の生成
$sshConfig = @"
Host ${instanceName}
    User ec2-user
    Port 22
    ProxyCommand powershell.exe aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters portNumber=%p
    HostName ${instanceId}
    IdentityFile ${keyFilePath}
"@
Set-Content -Path $sshConfigFilePath -Value $sshConfig

## VSCodeの起動
code --remote "ssh-remote+${instanceName}" "${remoteHomeDirPath}"

## 削除バッチの生成
$deleteBat = @"
@REM SSHConfの削除
@RD /S /Q "${sshConfigDirPath}"
@REM リソースの削除
aws cloudformation delete-stack --stack-name "${stackName}"
@DEL %0
"@
Set-Content -Path $deleteBatFilePath -Value $deleteBat