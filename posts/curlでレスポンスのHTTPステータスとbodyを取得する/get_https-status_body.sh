#!/bin/bash

response=$(curl -w '\n%{http_code}' -sL --url https://szk302.dev)

echo "status: ${response: -3}"
echo "body: ${response:0:-3}"