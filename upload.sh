#!/bin/bash

# Check argument
if [[ "$#" == '0' ]]; then
    echo "ERROR: No file specified!"
    exit 1
fi

FILE="$1"

# Check if file exists
if [[ ! -f "$FILE" ]]; then
    echo "ERROR: File not found: $FILE"
    exit 1
fi

# Upload to GoFile
UPLOAD_RESPONSE=$(curl -sS \
    -F "file=@$FILE" \
    "https://upload.gofile.io/uploadfile")

# Validate JSON response
if ! echo "$UPLOAD_RESPONSE" | jq . >/dev/null 2>&1; then
    echo "Error: upload failed (invalid JSON response):"
    echo "$UPLOAD_RESPONSE"
    exit 1
fi

# Check API status
STATUS=$(echo "$UPLOAD_RESPONSE" | jq -r '.status')
if [[ "$STATUS" != "ok" ]]; then
    echo "Error: upload failed:"
    echo "$UPLOAD_RESPONSE" | jq .
    exit 1
fi

# Get download link
LINK=$(echo "$UPLOAD_RESPONSE" | jq -r '.data.downloadPage')

# Validate link
if [[ -z "$LINK" || "$LINK" == "null" ]]; then
    echo "Error: could not retrieve download link"
    echo "$UPLOAD_RESPONSE" | jq .
    exit 1
fi

echo
echo "Upload successful!"
echo "Download link:"
echo "$LINK"
echo
