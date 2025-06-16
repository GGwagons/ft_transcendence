#!/bin/bash

IP=$(hostname -I | awk '{print $1}')
baseUrl="https://$IP/api"
wssUrl="wss://$IP/api/"

cat <<EOF > "${PWD}/frontend_ui/src/utils.ts"
export function getApiUrl(endpoint: string): string {
    return window.location.hostname === 'localhost' ? \`https://localhost/api/\${endpoint}\` : \`${baseUrl}/\${endpoint}\`;
}

export function getApiUrlAvatar(): string {
    return window.location.hostname === 'localhost' ? 'https://localhost/api' : \`${baseUrl}\`;
}

export const wssUrl =  window.location.hostname === 'localhost' ? \`wss://localhost/api/\` : \`${wssUrl}\`;
EOF