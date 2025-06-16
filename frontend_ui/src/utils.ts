export function getApiUrl(endpoint: string): string {
    return window.location.hostname === 'localhost' ? `https://localhost/api/${endpoint}` : `https://___/api/${endpoint}`; //"___" will get replaced with theJoke.sh
}

export function getApiUrlAvatar(): string {
    return window.location.hostname === 'localhost' ? 'https://localhost/api' : `https://___/api`; //"___" will get replaced with theJoke.sh
}

export const wssUrl =  window.location.hostname === 'localhost' ? `wss://localhost/api/` : `wss://___/api/`; //"___" will get replaced with theJoke.sh
