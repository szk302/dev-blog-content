$INPUT_FILE_PATH="sample.json"
$OUTPUT_FILE_PATH="sample_cp.json"

$jsonObj=(Get-Content -Path "${INPUT_FILE_PATH}" -Encodin UTF8 -Raw | ConvertFrom-Json)
ConvertTo-Json ${jsonObj} -Depth 32 | ForEach-Object { [Text.Encoding]::UTF8.GetBytes($_) } | Set-Content -Path "${OUTPUT_FILE_PATH}" -Encoding Byte
