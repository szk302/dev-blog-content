#!/bin/bash

startTime=$(date +"%s%3N")
sleep 1
response=$(curl -w '\n%{http_code}' -sL --request GET --url https://szk302.dev)
endTime=$(date +"%s%3N")

elapsedTime=$((endTime - startTime))
elapsedTimeSeconds=$(bc <<< "scale=3; $elapsedTime/1000")

echo "elapsedTime(ms):${elapsedTime}"
echo "elapsedTime(s):${elapsedTimeSeconds}"

