#!/bin/bash

# Verifica argumento
if [[ "$#" == '0' ]]; then
    echo "ERROR: No File Specified!"
    exit 1
fi

FILE="$1"

# Pega servidor
SERVER_RESPONSE=$(curl -s https://api.gofile.io/servers)

# Valida JSON
if ! echo "$SERVER_RESPONSE" | jq . >/dev/null 2>&1; then
    echo "Erro ao obter servidor (resposta inválida):"
    echo "$SERVER_RESPONSE"
    exit 1
fi

SERVER=$(echo "$SERVER_RESPONSE" | jq -r '.data.servers[0].name')

# Verifica se veio vazio
if [[ -z "$SERVER" || "$SERVER" == "null" ]]; then
    echo "Erro: servidor não encontrado"
    exit 1
fi

echo "Servidor: $SERVER"

# Upload
UPLOAD_RESPONSE=$(curl -# -F "file=@$FILE" "https://${SERVER}.gofile.io/uploadFile")

# Valida JSON novamente
if ! echo "$UPLOAD_RESPONSE" | jq . >/dev/null 2>&1; then
    echo "Erro no upload (resposta inválida):"
    echo "$UPLOAD_RESPONSE"
    exit 1
fi

LINK=$(echo "$UPLOAD_RESPONSE" | jq -r '.data.downloadPage')

# Valida link
if [[ -z "$LINK" || "$LINK" == "null" ]]; then
    echo "Erro: não foi possível obter o link"
    echo "$UPLOAD_RESPONSE"
    exit 1
fi

echo ""
echo "Download:"
echo "$LINK"
echo ""