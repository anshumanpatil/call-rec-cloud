# syntax=docker/dockerfile:1

FROM node:20-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

FROM httpd:2.4-alpine

# Enable rewrite and allow .htaccess overrides for SPA fallback.
RUN sed -i 's/#LoadModule rewrite_module modules\/mod_rewrite.so/LoadModule rewrite_module modules\/mod_rewrite.so/' /usr/local/apache2/conf/httpd.conf \
    && sed -i 's/AllowOverride None/AllowOverride All/' /usr/local/apache2/conf/httpd.conf

COPY --from=builder /app/build/ /usr/local/apache2/htdocs/

# React Router fallback: serve index.html for non-file requests.
RUN printf '%s\n' \
    'RewriteEngine On' \
    'RewriteBase /' \
    'RewriteRule ^index\.html$ - [L]' \
    'RewriteCond %{REQUEST_FILENAME} !-f' \
    'RewriteCond %{REQUEST_FILENAME} !-d' \
    'RewriteRule . /index.html [L]' \
    > /usr/local/apache2/htdocs/.htaccess

EXPOSE 80
