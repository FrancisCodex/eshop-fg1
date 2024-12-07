<?php
// Database connection details
$host = 'localhost'; // Database host
$port = '3306'; // Database port
$user = 'root'; // Database user
$dbname = 'eshop';
$pass = ''; // Database password

try {
    // Create a new PDO instance without specifying the database name
    $dsn = "mysql:host=$host;port=$port;charset=utf8";
    $options = [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION, // Turn on errors in the form of exceptions
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC, // Fetch associative arrays by default
        PDO::ATTR_EMULATE_PREPARES => false, // Disable emulation mode for prepared statements
    ];
    
    // Establish a connection
    $conn = new PDO($dsn, $user, $pass, $options);

    // Select the database
    $conn->exec("USE `$dbname`");
} catch (PDOException $e) {
    // Output error message in JSON format
    echo json_encode(['error' => 'Database connection failed: ' . $e->getMessage()]);
    exit;
}