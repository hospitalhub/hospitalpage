<?php

$protocol = $_SERVER["SERVER_PROTOCOL"];
if ( 'HTTP/1.1' != $protocol && 'HTTP/1.0' != $protocol)
	$protocol = 'HTTP/1.0';
header( "$protocol 503 Service Unavailable", true, 503 );
header( 'Content-Type: text/html; charset=utf-8' );
?>

<html xmlns="http://www.w3.org/1999/xhtml">

<body>
	<h1> Serwis chwilowo niedostępny. </h1>
</body>
</html>

<?php die(); ?>

