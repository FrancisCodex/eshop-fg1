<?php
// Database connection
$host = 'localhost'; // Database host
$db = 'eshop-fg1'; // Database name
$user = 'root'; // Database user
$pass = ''; // Database password

try {
    $conn = new PDO("mysql:host=$host;dbname=$db", $user, $pass);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode(['error' => 'Database connection failed: ' . $e->getMessage()]);
    exit;
}
