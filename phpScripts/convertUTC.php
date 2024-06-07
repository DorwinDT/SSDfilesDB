<?php
/* 
 * Class MyJablotron - JA100
 * (c)2022 Peter Turcan
 */
include('settings.php');
include('myjablotron.class.php');
$temperatureTable = "Temperature_2";

define('MY_COOKIE_FILE', '/tmp/cookies.txt'); // curl store cookies

print "Jabloscan v1.0 (c)2022 Peter Turcan\n";



$con = mysqli_connect($dbServer, $dbUser, $dbPassword, $dbname);

if ($con === false) {
	die("ERROR: Could not connect. " . mysqli_connect_error());
}
$sql = "SELECT * FROM Temperature";
$cnt = 0;
if ($result = mysqli_query($con, $sql)) {
	if (mysqli_num_rows($result) > 0) {
		while ($row = mysqli_fetch_array($result)) {
			$sensorID = $row['sensor_id'];
			$temperature = $row['temperature'];
			$timestamp = $row['timestamp'];
			$cnt++;
		}
	}
};

print "Rows converted: "  . $cnt . "\n";

?>