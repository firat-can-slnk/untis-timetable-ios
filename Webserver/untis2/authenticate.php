<?php

//The url you wish to send the POST request to
$server = $_GET["server"];
$school = $_GET["school"];

$url = "https://$server/WebUntis/jsonrpc.do?school=$school";

$jsonParamsUser = $_GET["jsonParamsUser"];
$jsonParamsPassword = $_GET["jsonParamsPassword"];
$jsonParamsClient = $_GET["jsonParamsClient"];
$jsonID = $_GET["jsonID"];
$jsonMethod = $_GET["jsonMethod"];
$jsonRPC = "2.0";

$jsonParams = array('user' => $jsonParamsUser,
                    'password' => $jsonParamsPassword,
                    'client' => $jsonParamsClient);
$jsonData = array('id' => $jsonID,
                  'method' => $jsonMethod,
                  'params' => $jsonParams,
                  'jsonrpc' => $jsonRPC);

$content = json_encode($jsonData);

$curl = curl_init($url);
curl_setopt($curl, CURLOPT_HEADER, false);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
curl_setopt($curl, CURLOPT_HTTPHEADER,
        array("Content-type: application/json"));
curl_setopt($curl, CURLOPT_POST, true);
curl_setopt($curl, CURLOPT_POSTFIELDS, $content);

$json_response = curl_exec($curl);

$status = curl_getinfo($curl, CURLINFO_HTTP_CODE);


curl_close($curl);

  $response = json_decode($json_response, true);
  print_r($response);
  require_once("config.php");
  $conn = new mysqli($DB_HOSTNAME, $DB_USERNAME, $DB_PASSWORD, $DB_NAME);
  try {
  $stmt = $conn->prepare('INSERT INTO `authenticate` (`ID`, `Server`, `School`, `User`, `Password`, `Client`, `sessionID`, `personID`, `personType`, `klasseID`) VALUES (NULL, ? , ? , ? , ? , ? , ? , ? , ? , ?)');
  $stmt->bind_param('sssssssss',
  $server,
  $school,
  $jsonParamsUser,
  $jsonParamsPassword,
  $jsonParamsClient,
  $response["result"]["sessionId"],
  $response["result"]["personType"],
  $response["result"]["personId"],
  $response["result"]["klasseId"]); // 's' specifies the variable type => 'string'

  $stmt->execute();


  $stmt->close();
  $conn->close();


} catch (\Exception $e) {
  echo "Error while inserting to database: $e";
}
  require_once("configr.php");


?>
