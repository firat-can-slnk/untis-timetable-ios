<?php
ini_set('display_errors', 1);
error_reporting(1);
require 'mainClass.php';
require 'config.php';
$server = $_GET["server"];
$school = $_GET["school"];
$jsonParamsUser = $_GET["jsonParamsUser"];
$jsonParamsPassword = $_GET["jsonParamsPassword"];
$jsonParamsClient = $_GET["jsonParamsClient"];
$jsonID = $_GET["jsonID"];
$jsonMethod = $_GET["jsonMethod"];
$date = $_GET["date"];

$untis = new Untis($server, $school, $jsonParamsUser, $jsonParamsPassword, $jsonParamsClient, $jsonID, $date);

$untis->sessionID = $untis->authenticate();
$untis->getJSON();
$lessons = $untis->getLesson();
$mergedLessons = $untis->mergeLessons($lessons);

print_r(json_encode($mergedLessons));
 
 ?>
