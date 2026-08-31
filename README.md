<p align="center"><a href="https://laravel.com" target="_blank"><img src="https://raw.githubusercontent.com/laravel/art/master/logo-lockup/5%20SVG/2%20CMYK/1%20Full%20Color/laravel-logolockup-cmyk-red.svg" width="400" alt="Laravel Logo"></a></p>

<p align="center">
<a href="https://github.com/laravel/framework/actions"><img src="https://github.com/laravel/framework/workflows/tests/badge.svg" alt="Build Status"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/dt/laravel/framework" alt="Total Downloads"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/v/laravel/framework" alt="Latest Stable Version"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/l/laravel/framework" alt="License"></a>
</p>

## Barangay San Jose — local setup

The app runs on MySQL. `database/barangayapp.sql` is a schema + seed-data dump
of that database.

```bash
composer install
cp .env.example .env          # Windows: copy .env.example .env
php artisan key:generate

php artisan db:create         # creates the `barangayapp` database (utf8mb4_unicode_ci)
php artisan migrate           # builds the tables
php artisan db:seed           # admin account only (see DatabaseSeeder)

npm install && npm run dev
php artisan serve
```

`composer setup` runs the same steps in one go.

Run `db:create` before the first `migrate`. Laravel will happily create a
missing MySQL database on its own, but with the server's default collation;
`db:create` uses the `utf8mb4_unicode_ci` that the dump and production use.

`FacilitySeeder`, `EquipmentSeeder` and `TransactionTypeSeeder` are not part of
`db:seed`; run them individually (`php artisan db:seed --class=FacilitySeeder`)
if you want the sample catalog.

To start from the committed dump instead of empty tables, import it and then
migrate — the dump predates the most recent migrations, so `migrate` still has
work to do:

```bash
mysql -u root -p < database/barangayapp.sql
php artisan migrate
```

### "Unknown database 'barangayapp'"

```
SQLSTATE[HY000] [1049] Unknown database 'barangayapp'
(Connection: mysql, Host: 127.0.0.1, Port: 3306, Database: barangayapp,
 SQL: select * from `sessions` where `id` = ...)
```

The MySQL server is reachable but has no `barangayapp` database, so every
request fails — including the session lookup that runs before your own code.
Run `php artisan db:create && php artisan migrate` to create it.

If that reports a connection error rather than creating the database, the
server itself is not reachable: start MySQL (XAMPP/Laragon control panel, or
`brew services start mysql`) and check `DB_HOST`, `DB_PORT`, `DB_USERNAME` and
`DB_PASSWORD` in `.env`. After editing `.env`, run `php artisan config:clear`.

## About Laravel

Laravel is a web application framework with expressive, elegant syntax. We believe development must be an enjoyable and creative experience to be truly fulfilling. Laravel takes the pain out of development by easing common tasks used in many web projects, such as:

- [Simple, fast routing engine](https://laravel.com/docs/routing).
- [Powerful dependency injection container](https://laravel.com/docs/container).
- Multiple back-ends for [session](https://laravel.com/docs/session) and [cache](https://laravel.com/docs/cache) storage.
- Expressive, intuitive [database ORM](https://laravel.com/docs/eloquent).
- Database agnostic [schema migrations](https://laravel.com/docs/migrations).
- [Robust background job processing](https://laravel.com/docs/queues).
- [Real-time event broadcasting](https://laravel.com/docs/broadcasting).

Laravel is accessible, powerful, and provides tools required for large, robust applications.

## Learning Laravel

Laravel has the most extensive and thorough [documentation](https://laravel.com/docs) and video tutorial library of all modern web application frameworks, making it a breeze to get started with the framework.

In addition, [Laracasts](https://laracasts.com) contains thousands of video tutorials on a range of topics including Laravel, modern PHP, unit testing, and JavaScript. Boost your skills by digging into our comprehensive video library.

You can also watch bite-sized lessons with real-world projects on [Laravel Learn](https://laravel.com/learn), where you will be guided through building a Laravel application from scratch while learning PHP fundamentals.

## Agentic Development

Laravel's predictable structure and conventions make it ideal for AI coding agents like Claude Code, Cursor, and GitHub Copilot. Install [Laravel Boost](https://laravel.com/docs/ai) to supercharge your AI workflow:

```bash
composer require laravel/boost --dev

php artisan boost:install
```

Boost provides your agent 15+ tools and skills that help agents build Laravel applications while following best practices.

## Contributing

Thank you for considering contributing to the Laravel framework! The contribution guide can be found in the [Laravel documentation](https://laravel.com/docs/contributions).

## Code of Conduct

In order to ensure that the Laravel community is welcoming to all, please review and abide by the [Code of Conduct](https://laravel.com/docs/contributions#code-of-conduct).

## Security Vulnerabilities

If you discover a security vulnerability within Laravel, please send an e-mail to Taylor Otwell via [taylor@laravel.com](mailto:taylor@laravel.com). All security vulnerabilities will be promptly addressed.

## License

The Laravel framework is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).
