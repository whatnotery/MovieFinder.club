function setCookie(name, value, options = {}) {
    let cookieString = `${encodeURIComponent(name)}=${encodeURIComponent(value)}`;

    if (options.expires instanceof Date) {
        cookieString += `; expires=${options.expires.toUTCString()}`;
    }

    if (options.path) {
        cookieString += `; path=${options.path}`;
    }

    if (options.domain) {
        cookieString += `; domain=${options.domain}`;
    }

    if (options.secure) {
        cookieString += '; Secure';
    }

    if (options.httpOnly) {
        cookieString += '; HttpOnly';
    }

    document.cookie = cookieString;
}

// Function to retrieve a cookie by name
function getCookie(name) {
    const cookies = document.cookie.split(';');
    for (let cookie of cookies) {
        const [cookieName, cookieValue] = cookie.trim().split('=');
        if (decodeURIComponent(cookieName) === name) {
            return decodeURIComponent(cookieValue);
        }
    }
    return null;
}

// Function to parse response headers and set cookies accordingly
function setCookiesFromResponse(responseHeaders) {
    const setCookieHeaders = responseHeaders
        .getAll('Set-Cookie')
        .map(cookie => cookie.split(';')[0]); // Extract only the cookie name and value

    setCookieHeaders.forEach(cookie => {
        const [name, value] = cookie.split('=');
        setCookie(name, value);
    });
}

export { setCookie, getCookie, setCookiesFromResponse };