#!/usr/bin/env bash
set -e

echo "==> Starting Laravel deployment tasks..."

# Generate application key if APP_KEY is not set
if [ -z "$APP_KEY" ]; then
    echo "==> APP_KEY not set — generating application key..."
    php artisan key:generate --force
else
    echo "==> APP_KEY already set, skipping key:generate."
fi

# Cache config with real runtime environment variables
echo "==> Caching configuration..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Run database migrations
echo "==> Running database migrations..."
php artisan migrate --force

# Create storage symlink
echo "==> Linking storage..."
php artisan storage:link --force 2>/dev/null || true

echo "==> All tasks complete. Starting server on port ${PORT:-8000}..."

# Start the web server
exec php artisan serve --host=0.0.0.0 --port="${PORT:-8000}"
