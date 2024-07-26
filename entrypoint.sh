#!/bin/sh

# Ensure directories exist
for dir in /data/conf /data/work /var/run/tailscale /var/cache/tailscale /var/lib/tailscale; do
    [ ! -d "$dir" ] && mkdir -p "$dir"
done

# Set permissions and ownership
chmod +x /usr/local/bin/tailscaled /usr/local/bin/tailscale
chown www-data:www-data /etc/phpmyadmin/config.secret.inc.php
chmod 600 /etc/phpmyadmin/config.secret.inc.php

# Start tailscaled and wait for it to initialize
tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &

sleep 5

# Start tailscale with provided authentication key and hostname
tailscale up --ssh --authkey="${TAILSCALE_AUTHKEY}" --hostname="${TAILSCALE_HOSTNAME}"
tailscale cert "${TAILSCALE_HOSTNAME}"."${TAILSCALE_DNS}"

# Start PHP-FPM and Nginx
php-fpm -F &
nginx -g "daemon off;"

# Keep the script running indefinitely
sleep infinity