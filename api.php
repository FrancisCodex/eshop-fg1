<?php
require 'vendor/autoload.php';

use Phpfastcache\Helper\Psr16Adapter;

$cache = new Psr16Adapter('Files');

// Rate limiting settings
$rateLimit = 100;
$rateLimitTime = 3600;

// List of valid API keys
$validApiKeys = [
    'test',
];

// Function to sanitize cache key
function sanitizeCacheKey($key) {
    return preg_replace('/[^a-zA-Z0-9_]/', '_', $key);
}

// Function to check rate limit
function checkRateLimit($ip) {
    global $cache, $rateLimit, $rateLimitTime;

    $cacheKey = 'rate_limit_' . sanitizeCacheKey($ip);
    $requestCount = $cache->get($cacheKey);

    if ($requestCount === null) {
        $cache->set($cacheKey, 1, $rateLimitTime);
    } else {
        if ($requestCount >= $rateLimit) {
            http_response_code(429);
            echo 'Rate limit exceeded';
            exit;
        } else {
            $cache->set($cacheKey, $requestCount + 1, $rateLimitTime);
        }
    }
}

// Function to validate API key
function validateApiKey($apiKey) {
    global $validApiKeys;
    return in_array($apiKey, $validApiKeys);
}

// Function to forward requests to microservices with caching
function forwardRequest($url, $method, $data = null) {
    global $cache;

    $cacheKey = md5($url . $method . json_encode($data));
    $cachedResponse = $cache->get($cacheKey);

    if ($cachedResponse) {
        return $cachedResponse;
    }

    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method);

    if ($data) {
        curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data));
    }

    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, array(
        'Content-Type: application/x-www-form-urlencoded'
    ));

    $response = curl_exec($ch);
    curl_close($ch);

    $cache->set($cacheKey, $response, 300);

    return $response;
}

// Get the request path and method
$requestPath = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$requestMethod = $_SERVER['REQUEST_METHOD'];

// Get the client IP address
$clientIp = $_SERVER['REMOTE_ADDR'];

// Check rate limit
checkRateLimit($clientIp);

// Get all headers
$headers = getallheaders();
$cleanHeaders = array();
foreach ($headers as $key => $value) {
    $cleanHeaders[trim($key)] = trim($value);
}

// Validate API key
$apiKey = isset($cleanHeaders['API_KEY']) ? $cleanHeaders['API_KEY'] : '';
if (!validateApiKey($apiKey)) {
    http_response_code(401);
    echo 'Invalid API key';
    exit;
}

// Simple routing
switch ($requestPath) {
    case '/api/auth':
        $serviceUrl = 'http://meow.com';
        break;
    case '/api/products':
        $serviceUrl = 'http://arf.com';
        break;
    case '/api/cart':
        $serviceUrl = 'http://ror.com';
        break;
    case '/api/hi':
        header('Content-Type: application/json');
        echo json_encode(['message' => 'Kumusta Kalibutan!', 'Pisot Ka' => 'true']);
        exit;
    default:
        http_response_code(404);
        echo 'Endpoint not found';
        exit;
}

// Forward the request to the corresponding microservice
$response = forwardRequest($serviceUrl, $requestMethod, $_POST);
echo $response;