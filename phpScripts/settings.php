<?php
$config = parse_ini_file('/config/config.ini');

$dbServer = 'db';
$dbname = $config['MYSQL_DATABASE'];
$dbUser = $config['MYSQL_USER'];
$dbPassword = $config['MYSQL_PASSWORD'];

$eicDirectory = '/SSD';

?>