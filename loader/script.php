<?php
header("Content-Type: text/plain");


$ua = $_SERVER['HTTP_USER_AGENT'] ?? '';
if (preg_match('/Mozilla|Chrome|Firefox|Safari|Edge|Opera|MSIE|Trident|curl|wget/i', $ua)) {
    http_response_code(403);
    die("Forbidden");
}
echo "print('Sirius loader started!')\n";
echo "-- rest of your Lua here\n";
?>
