<?php
include('settings.php');


define('MY_COOKIE_FILE', '/tmp/cookies.txt'); // curl store cookies

print "EIC import v1.0 (c)2022 Peter Turcan\n";
print "source: " . $eicDirectory . "\n";

$con = mysqli_connect($dbServer, $dbUser, $dbPassword, $dbname);

if ($con === false) {
	die("ERROR: Could not connect. " . mysqli_connect_error());
}


$inputCSV = glob($eicDirectory . '/*.csv', GLOB_BRACE); // get all CSV's in directory

foreach($inputCSV as $fullFnm)  // iterate through all find files
{
    # full path to file
    $fnm = basename($fullFnm);  // filename without directory path
    $sql = "SELECT * FROM EIC_File where filename = '" . $fnm . "'";
    $found = false;
    if ($result = mysqli_query($con, $sql)) {
        if (mysqli_num_rows($result) > 0) {
            $found = true;
        }
    }

    if (!$found)
    {
        print "Importing: " . $fnm . "\n";
        // store filename into MSSQL database
            $sql = "insert into EIC_File (filename) values ('"
            . $fnm
            . "'"
            . ")";
        mysqli_query($con, $sql);+  // vlozime do DB novy zaznam k suboru

        //precitame jeho ID
        $idFile = 0;
        $sql = "SELECT * FROM EIC_File where filename = '" . $fnm . "'";
        $found = false;
        if ($result = mysqli_query($con, $sql)) {
            if (mysqli_num_rows($result) > 0) {
                while ($row = mysqli_fetch_array($result)) {
					$idFile = $row['id'];
				}
                
            }
        }
        print "Filename id:" . $idFile;
        // parsujeme CSV
        $row = 1;
        if (($handle = fopen($fullFnm, "r")) !== FALSE) {
            while (($data = fgetcsv($handle, 1000, ";")) !== FALSE) {
                $num = count($data);
                $row++;
                if ($row > 2)
                {
                    //echo "$num fields in line $row:\n";
                    $eic = $data[0];
                    $datum = $data[1];
                    $odber = $data[3];
                    $odber = str_replace(',', '.', $odber);
                    $dodavka = $data[5];
                    $dodavka = str_replace(',', '.', $dodavka);
                    //preformatujeme datum
                    $ar1 = explode(" " , $datum);
                    $ar2 = explode("." , $ar1[0]);
                    $datum = $ar2[2] . "-" . $ar2[1] . "-" . $ar2[0]. " " . $ar1[1];

                    $newDateTime = new DateTime($datum, new DateTimeZone('Europe/Bratislava')); 
                    $newDateTime->setTimezone(new DateTimeZone("UTC")); 
                    $datum = $newDateTime->format("Y-m-d H:i:s");

                    //print "EIC:" . $eic . " Date:" . $datum . " odber:" . $odber . "\n";
                    $sql = "INSERT INTO ElectricityConsumption (eic_id, consumption, `timestamp`, EIC_filename_id, export) VALUES(" 
                        . 1
                        . ","
                        . $odber
                        . ",'"
                        . $datum
                        . "',"
                        . $idFile
                        . ",'"
                        . $dodavka
                        . "')";
                    mysqli_query($con, $sql);
                }
            }
            fclose($handle);
        }
        print "DONE\n";
    } else
    {
        print "File: " . $fnm . " is already imported\n";
    }
}
?>