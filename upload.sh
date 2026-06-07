#!/bin/bash

# Check argument
if [[ "$#" == '0' ]]; then
    echo "ERROR: No file specified!"
    exit 1
fi

FILE="$1"

# Upload directly to the fixed endpoint (no server selection needed since 2025)
UPLOAD_RESPONSE=$(curl -# -F "file=@$FILE" "https://upload.gofile.io/uploadfile")

# Validate JSON response
if ! echo "$UPLOAD_RESPONSE" | jq . >/dev/null 2>&1; then
    echo "Error: upload failed (invalid response):"
    echo "$UPLOAD_RESPONSE"
    exit 1
fi

LINK=$(echo "$UPLOAD_RESPONSE" | jq -r '.data.downloadPage')

# Validate link
if [[ -z "$LINK" || "$LINK" == "null" ]]; then
    echo "Error: could not retrieve download link"
    echo "$UPLOAD_RESPONSE"
    exit 1
fi

echo ""
echo "Download link:"
echo "$LINK"
echo ""