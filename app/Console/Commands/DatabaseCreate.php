<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use PDO;
use PDOException;

/**
 * Creates the configured database if the server does not have it yet.
 *
 * A missing database breaks every request, not just migrations: the session
 * lookup in StartSession fails with "Unknown database 'barangayapp'" before
 * any application code runs. This command connects to the server *without*
 * selecting a database and issues the CREATE, so the app can boot again.
 *
 * `php artisan migrate` will also create a missing MySQL database, but it uses
 * the server's default collation. This command uses the charset and collation
 * from config/database.php (utf8mb4 / utf8mb4_unicode_ci), which is what
 * database/barangayapp.sql and production are built with — so run it before
 * the first migrate rather than after.
 */
class DatabaseCreate extends Command
{
    protected $signature = 'db:create
                            {--connection= : Connection to create (defaults to DB_CONNECTION)}';

    protected $description = 'Create the configured database if it does not already exist';

    public function handle(): int
    {
        $name = $this->option('connection') ?: config('database.default');
        $config = config("database.connections.{$name}");

        if (! $config) {
            $this->error("No database connection named [{$name}] is configured.");

            return self::FAILURE;
        }

        return match ($config['driver']) {
            'sqlite' => $this->createSqlite($config),
            'mysql', 'mariadb' => $this->createMysql($config),
            default => $this->unsupported($config['driver']),
        };
    }

    private function createSqlite(array $config): int
    {
        $path = $config['database'];

        if ($path === ':memory:') {
            $this->info('The sqlite connection is in-memory; there is nothing to create.');

            return self::SUCCESS;
        }

        if (file_exists($path)) {
            $this->info("Database file [{$path}] already exists.");

            return self::SUCCESS;
        }

        if (! is_dir(dirname($path))) {
            $this->error('Directory ['.dirname($path).'] does not exist.');

            return self::FAILURE;
        }

        // A bare name with no directory and no extension is almost always a
        // leftover MySQL DB_DATABASE next to DB_CONNECTION=sqlite; creating it
        // would leave a junk file in the project root.
        if (dirname($path) === '.' && pathinfo($path, PATHINFO_EXTENSION) === '') {
            $this->error("DB_DATABASE is set to [{$path}], which is not a sqlite file path.");
            $this->line('Either point DB_DATABASE at a .sqlite file, remove it to use the default (database/database.sqlite), or set DB_CONNECTION=mysql.');

            return self::FAILURE;
        }

        touch($path);
        $this->info("Created database file [{$path}].");

        return self::SUCCESS;
    }

    private function createMysql(array $config): int
    {
        $database = (string) $config['database'];

        // The name goes into the statement as an identifier, so it can never be
        // bound as a parameter. Only allow what MySQL accepts unquoted.
        if (! preg_match('/^[A-Za-z0-9_]+$/', $database)) {
            $this->error("Refusing to create database [{$database}]: the name must contain only letters, digits and underscores.");

            return self::FAILURE;
        }

        $charset = $this->identifier($config['charset'] ?? null, 'utf8mb4');
        $collation = $this->identifier($config['collation'] ?? null, 'utf8mb4_unicode_ci');

        try {
            $pdo = new PDO(
                $this->serverDsn($config),
                $config['username'] ?? null,
                $config['password'] ?? null,
                ($config['options'] ?? []) + [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION],
            );

            $existed = (bool) $pdo->query(
                'SELECT 1 FROM information_schema.schemata WHERE schema_name = '.$pdo->quote($database)
            )->fetchColumn();

            $pdo->exec("CREATE DATABASE IF NOT EXISTS `{$database}` CHARACTER SET {$charset} COLLATE {$collation}");
        } catch (PDOException $e) {
            $this->error("Could not create database [{$database}]: ".$e->getMessage());
            $this->line('Check DB_HOST, DB_PORT, DB_USERNAME and DB_PASSWORD in your .env, and that the server is running.');

            return self::FAILURE;
        }

        if ($existed) {
            $this->info("Database [{$database}] already exists.");
        } else {
            $this->info("Created database [{$database}] ({$charset} / {$collation}).");
            $this->line('Next: php artisan migrate');
        }

        return self::SUCCESS;
    }

    /**
     * Build a DSN that reaches the server without selecting a database.
     */
    private function serverDsn(array $config): string
    {
        if (! empty($config['unix_socket'])) {
            return "mysql:unix_socket={$config['unix_socket']}";
        }

        $host = $config['host'] ?: '127.0.0.1';
        $port = $config['port'] ?? null;

        return $port ? "mysql:host={$host};port={$port}" : "mysql:host={$host}";
    }

    private function identifier(?string $value, string $fallback): string
    {
        return $value !== null && preg_match('/^[A-Za-z0-9_]+$/', $value) ? $value : $fallback;
    }

    private function unsupported(string $driver): int
    {
        $this->error("Creating a database for the [{$driver}] driver is not supported; create it with your database client instead.");

        return self::FAILURE;
    }
}
