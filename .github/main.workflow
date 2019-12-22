name: CI

on: pull_request

jobs:
  laravel-tests:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1
    - name: Copy .env
      run: php -r "file_exists('.env') || copy('.env.testing', '.env');"
    - name: Install Dependencies & Build
      run: |
        composer install -q --no-ansi --no-interaction --no-scripts --no-suggest --no-progress --prefer-dist
        yarn install
        yarn prod
    - name: Generate key
      run: |
        php artisan key:generate
        php artisan config:cache
    - name: Create Database
      run: echo 'create database laravel' | mysql -u root -proot
    - name: Execute tests (Unit and Feature tests) via PHPUnit
      run: vendor/bin/phpunit
    - name: Upgrade Chrome Driver
      run: php artisan dusk:chrome-driver 77
    - name: Start Chrome Driver
      run: |
        chmod -R 0755 vendor/laravel/dusk/bin
        ./vendor/laravel/dusk/bin/chromedriver-linux > /dev/null 2>&1 &
    - name: Run Laravel Server
      run: php artisan serve > /dev/null 2>&1 &
    - name: Run Dusk Tests
      run: php artisan dusk
