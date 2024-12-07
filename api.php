<?php
require 'vendor/autoload.php';
use Phpfastcache\Helper\Psr16Adapter;
use Phpfastcache\Config\ConfigurationOption;

if (!is_dir(__DIR__ . '/cache')) {
    mkdir(__DIR__ . '/cache', 0777, true);
}
if (!is_dir(__DIR__ . '/logs')) {
    mkdir(__DIR__ . '/logs', 0777, true);
}

$config = new ConfigurationOption([
    'path' => __DIR__ . '/cache'
]);

$cache = new Psr16Adapter('Files', $config);

const API_KEYS = [
    'test-key-1' => ['rate_limit' => 100, 'timeout' => 3600],
    'test-key-2' => ['rate_limit' => 200, 'timeout' => 3600]
];

$microservices = [
    'auth' => [
        'base_url' => 'http://localhost/eshop-fg1/api/auth',
        'endpoints' => [
            'login' => '/login',
            'register' => '/register',
            'logout' => '/logout',
            'password_reset' => [
                'request' => '/password/reset/request',
                'reset' => '/password/reset'
            ],
            'profile' => '/profile/{id}',
            'verify' => '/verify-email/{token}',
            'assign_role' => '/role/assign',
            'revoke_role' => '/role/revoke',
            'get_cart' => '/cart/{id}',
        ]
    ],
    'user' => [
        'base_url' => 'http://localhost/eshop-fg1/api/user',
        'endpoints' => [
            'cart' => '/cart',
            'profile' => '/profile/update/{id}'
        ]
    ],
    'products' => [
        'base_url' => 'http://localhost:8001/api.php/products',
        'endpoints' => [
            'list' => '/products',
            'categories' => '/categories', // Adjusted for direct access
            'single' => '/products/{id}',
            'search' => '/search/{query}'
        ]
    ],
];

// Validate API Key
function validateApiKey($apiKey) {
    if (!isset($_SERVER['HTTP_X_API_KEY'])) {
        return false;
    }
    return array_key_exists($_SERVER['HTTP_X_API_KEY'], API_KEYS);
}

// Rate Limiting
function checkRateLimit($apiKey) {
    global $cache;
    $key = "rate_limit_" . $apiKey;
    $count = $cache->get($key) ?? 0;
    
    if ($count >= API_KEYS[$apiKey]['rate_limit']) {
        return false;
    }
    
    $cache->set($key, $count + 1, API_KEYS[$apiKey]['timeout']);
    return true;
}

// Logger
function logRequest($request, $response, $status) {
    $log = [
        'timestamp' => date('Y-m-d H:i:s'),
        'method' => $_SERVER['REQUEST_METHOD'],
        'path' => $request,
        'status' => $status,
        'api_key' => $_SERVER['HTTP_X_API_KEY'] ?? 'none',
        'ip' => $_SERVER['REMOTE_ADDR']
    ];
    
    $logFile = __DIR__ . '/logs/api_access_for_' . date('Y-m-d') . '.log';
    file_put_contents($logFile, json_encode($log) . "\n", FILE_APPEND);
}

// Update forwardRequest function with error handling
function forwardRequest($url, $method, $data = null) {
    global $cache;
    
    // Add debug log
    error_log("Forwarding request to: " . $url);
    error_log("Method: " . $method);
    error_log("Data: " . json_encode($data));

    $cacheKey = md5($url . $method . json_encode($data));
    if ($method === 'GET') {
        $cached = $cache->get($cacheKey);
        if ($cached) return ['code' => 200, 'body' => $cached];
    }

    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    
    // Forward headers
    $headers = [];
    if (isset($_SERVER['HTTP_AUTHORIZATION'])) {
        $headers[] = 'Authorization: ' . $_SERVER['HTTP_AUTHORIZATION'];
    }
    if (isset($_SERVER['CONTENT_TYPE'])) {
        $headers[] = 'Content-Type: ' . $_SERVER['CONTENT_TYPE'];
    }
    $headers[] = 'Accept: application/json';
    
    if (!empty($headers)) {
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
    }
    
    if ($data) {
        curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
    }

    $response = curl_exec($ch);
    
    if (curl_errno($ch)) {
        curl_close($ch);
        return [
            'code' => 500,
            'body' => json_encode(['error' => 'Service unavailable'])
        ];
    }

    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    if ($method === 'GET' && $httpCode === 200) {
        $cache->set($cacheKey, $response, 300);
    }

    return [
        'code' => $httpCode ?: 500,
        'body' => $response ?: json_encode(['error' => 'Empty response'])
    ];
}

// Main Request Handler
header('Content-Type: application/json');

if (!validateApiKey($_SERVER['HTTP_X_API_KEY'] ?? '')) {
    http_response_code(401);
    echo json_encode(['error' => 'Invalid API key']);
    exit;
}

if (!checkRateLimit($_SERVER['HTTP_X_API_KEY'])) {
    http_response_code(429);
    echo json_encode(['error' => 'Too many requests']);
    exit;
}

$request = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$requestPath = preg_replace('/^\/api\.php\//', '', $request);
$pathParts = explode('/', trim($requestPath, '/'));
$requestMethod = $_SERVER['REQUEST_METHOD'];

if (count($pathParts) >= 1) {
    $service = $pathParts[0];
    
    if ($service === 'products' || $service === 'categories') {
        $baseUrl = 'http://localhost:8001/api.php';
        $endpoint = '/' . implode('/', $pathParts);
        $serviceUrl = $baseUrl . $endpoint;
    } elseif (isset($microservices[$service])) {
        $baseUrl = $microservices[$service]['base_url'];
        array_shift($pathParts);
        $endpoint = '/' . implode('/', $pathParts);
        $serviceUrl = $baseUrl . $endpoint;
    } else {
        http_response_code(404);
        echo json_encode(['error' => 'Service not found']);
        exit;
    }
    
    $input = file_get_contents('php://input');
    $data = $requestMethod === 'GET' ? $_GET : $input;
    
    $result = forwardRequest($serviceUrl, $requestMethod, $data);
    
    if (isset($result['code'])) {
        http_response_code($result['code']);
    } else {
        http_response_code(500);
    }
    
    logRequest($request, $result['body'] ?? '', $result['code'] ?? 500);
    
    if (isset($result['body'])) {
        echo $result['body'];
    } else {
        echo json_encode(['error' => 'Invalid response']);
    }
} else {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid request']);
}