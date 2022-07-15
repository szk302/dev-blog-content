$INPUT_FILE_PATH="sample.json"
$OUTPUT_FILE_PATH="sample_cp.json"

# json読み込み
$jsonObj=(Get-Content -Path "${INPUT_FILE_PATH}" -Encodin UTF8 -Raw | ConvertFrom-Json)

# プロパティの追加
$jsonObj | Add-Member -MemberType NoteProperty -Name 'Key3' -Value 'Added Value'
# プロパティの削除
$jsonObj.psobject.properties.remove('Key2')

# json書き出し
ConvertTo-Json ${jsonObj} -Depth 32 | ForEach-Object { [Text.Encoding]::UTF8.GetBytes($_) } | Set-Content -Path "${OUTPUT_FILE_PATH}" -Encoding Byte
