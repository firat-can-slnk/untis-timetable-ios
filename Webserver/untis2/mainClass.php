<?php
class Untis
{
  public $server;
  public $school;
  public $jsonParamsUser;
  public $jsonParamsPassword;
  public $jsonParamsClient;
  public $jsonID;
  public $date;
  public $sessionID;

  public $jsonRPC = "2.0";

  public $jsonArray;
  public $iCalProperties;

  public $elementID;

  public function __construct(string $server, string $school, string $jsonParamsUser, string $jsonParamsPassword, string $jsonParamsClient, string $jsonID, string $date)
  {
    $this->server = $server;
    $this->school = $school;
    $this->jsonParamsUser = $jsonParamsUser;
    $this->jsonParamsPassword = $jsonParamsPassword;
    $this->jsonParamsClient = $jsonParamsClient;
    $this->jsonID = $jsonID;
    $this->date = $date;
  }
  public function getKlassen()
  {
    return $this->jsonRequest("getKlassen", array());
  }

  function removeDuplicates($iCalProperties)
  {

    for ($x = 0; $x < 5; $x++) {
      for ($i = 0; $i < (count($iCalProperties) - 1); $i++) {
        if ($iCalProperties[$i] == $iCalProperties[$i + 1]) { // Wenn diese und nächste Stunde das selbe Fach

          unset($iCalProperties[$i + 1]);

          $i++;
        }
      }

      $iCalProperties = array_values($iCalProperties);
      sort($iCalProperties);
    }

    return $iCalProperties;
  }

  function mergeLessons($iCalProperties)
  {
    for ($x = 0; $x < 5; $x++) {
      for ($i = 0; $i < (count($iCalProperties) - 1); $i++) {
        if ($iCalProperties[$i]["subject"] == $iCalProperties[$i + 1]["subject"]) { // Wenn diese und nächste Stunde das selbe Fach
          if ($iCalProperties[$i]["room"] == $iCalProperties[$i + 1]["room"]) { // Wenn diese und nächste Stunde der selbe Raum
            if ($iCalProperties[$i]["teacher"] == $iCalProperties[$i + 1]["teacher"]) { // Wenn diese und nächste Stunde der selbe Lehrer
              if ($iCalProperties[$i]["dtend"] == $iCalProperties[$i + 1]["dtstart"]) { // Wenn diese Stunde endet und sofort die nächste anfängt

                $iCalProperties[$i]["dtend"] = $iCalProperties[$i + 1]["dtend"];
                unset($iCalProperties[$i + 1]);

                $i++;
              }
            }
          }
        }
      }

      $iCalProperties = array_values($iCalProperties);
      sort($iCalProperties);
    }

    for ($x = 0; $x < 5; $x++) {
      for ($i = 0; $i < (count($iCalProperties) - 2); $i++) {
        if ($iCalProperties[$i]["subject"] == $iCalProperties[$i + 2]["subject"]) { // Wenn diese und nächste Stunde das selbe Fach
          if ($iCalProperties[$i]["room"] == $iCalProperties[$i + 2]["room"]) { // Wenn diese und nächste Stunde der selbe Raum
            if ($iCalProperties[$i]["teacher"] == $iCalProperties[$i + 2]["teacher"]) { // Wenn diese und nächste Stunde der selbe Lehrer
              if ($iCalProperties[$i]["dtend"] == $iCalProperties[$i + 2]["dtstart"]) { // Wenn diese Stunde endet und sofort die nächste anfängt

                $iCalProperties[$i]["dtend"] = $iCalProperties[$i + 2]["dtend"];
                unset($iCalProperties[$i + 2]);

               

              }
            }
          }
        }
      }

      $iCalProperties = array_values($iCalProperties);
      sort($iCalProperties);
    }


    sort($iCalProperties);
    $iCalProperties = $this->removeDuplicates($iCalProperties);
    return $iCalProperties;
  }


  function generateICal($iCalProperties)
  {

    include 'ICS.php';

    $ics = new ICS($iCalProperties);
    $ics_file_contents = $ics->to_string();

    echo "$ics_file_contents";
  }

  function getRoomFromId($id)
  {

    $i = 0;
    foreach ($this->jsonArray["data"]["result"]["data"]["elements"] as $key) {

      if ($this->jsonArray["data"]["result"]["data"]["elements"][$i]["type"] == 4 && $this->jsonArray["data"]["result"]["data"]["elements"][$i]["id"] == $id) {
        return $this->jsonArray["data"]["result"]["data"]["elements"][$i]["displayname"];
      }
      $i++;
    }
  }
  function getTeacherFromId($id)
  {


    $i = 0;
    foreach ($this->jsonArray["data"]["result"]["data"]["elements"] as $key) {

      if ($this->jsonArray["data"]["result"]["data"]["elements"][$i]["type"] == 2 && $this->jsonArray["data"]["result"]["data"]["elements"][$i]["id"] == $id) {
        return $this->jsonArray["data"]["result"]["data"]["elements"][$i]["displayname"];
      }
      $i++;
    }
  }
  function getSubjectFromId($id)
  {


    $i = 0;
    foreach ($this->jsonArray["data"]["result"]["data"]["elements"] as $key) {

      if ($this->jsonArray["data"]["result"]["data"]["elements"][$i]["type"] == 3 && $this->jsonArray["data"]["result"]["data"]["elements"][$i]["id"] == $id) {
        return $this->jsonArray["data"]["result"]["data"]["elements"][$i]["displayname"];
      }
      $i++;
    }
  }
  function getClassFromId($id)
  {


    $i = 0;
    foreach ($this->jsonArray["data"]["result"]["data"]["elements"] as $key) {

      if ($this->jsonArray["data"]["result"]["data"]["elements"][$i]["type"] == 1 && $this->jsonArray["data"]["result"]["data"]["elements"][$i]["id"] == $id) {
        return $this->jsonArray["data"]["result"]["data"]["elements"][$i]["displayname"];
      }
      $i++;
    }
  }

  function getLesson()
  {

    $iCalProperties = array(
      array(
        "subject" => "",
        "dtstart" => "",
        "dtend" => "",
        "room" => "",
        "teacher" => ""
      )
    );

    $base = $this->jsonArray["data"]["result"]["data"];

    //print_r($base);

    //  echo "Anzahl Elemente: ".count($base["elements"])." und Anzahl ElementPeriods: ". count($base["elementPeriods"]["$this->elementID"])."\n\n";
    for ($i = 0; $i < count($base["elements"]); $i++) {

      $id = $base["elements"][$i];

      for ($x = 0; $x < count($base["elementPeriods"]["$this->elementID"]); $x++) {
        $classID = "";
        $teacherID = "";
        $subjectID = "";
        $roomID = "";
        $studentID = "";

        foreach ($base["elementPeriods"]["$this->elementID"][$x]["elements"] as $key => $value) {
          switch ($value["type"]) {
            case '1':
              $classID = $key;

              //break;
            case '2':
              $teacherID = $key;

              //break;
            case '3':
              $subjectID = $key;

              //break;
            case '4':
              $roomID = $key;

              //break;
            case '5':
              $studentID = $key;

              //break;

            default:
              break;
          }
        }
        if ($classID != "") {
          // code...
        } else {
          // code...
        }
        if ($teacherID != "") {
          $teacher = $this->getTeacherFromId($base["elementPeriods"]["$this->elementID"][$x]["elements"][$teacherID]["id"]);
        } else {
          $teacher = "";
        }
        if ($subjectID != "") {
          $subject = $this->getSubjectFromId($base["elementPeriods"]["$this->elementID"][$x]["elements"][$subjectID]["id"]);
        } else {
          $subject = "";
        }
        if ($roomID != "") {
          $room = $this->getRoomFromId($base["elementPeriods"]["$this->elementID"][$x]["elements"][$roomID]["id"]);
        } else {
          $room = "";
        }
        if ($studentID != "") {
          // code...
        } else { }
        /**
                // echo "\n----------------\n";
                // echo "lessonId: ".$base["elementPeriods"]["$this->elementID"][$x]["lessonId"]. "\n";
                // echo "date: ".$base["elementPeriods"]["$this->elementID"][$x]["date"]. "\n";
                // echo "startTime: ".$base["elementPeriods"]["$this->elementID"][$x]["startTime"]. "\n";
                // echo "endTime: ".$base["elementPeriods"]["$this->elementID"][$x]["endTime"]. "\n";
                // echo "elements: ".$base["elementPeriods"]["$this->elementID"][$x]["elements"][2]["id"]. "\n";
        
        
              //if ($base["elementPeriods"]["$this->elementID"][$x]["elements"][$subjectID]["id"] == $id["id"] || $base["elementPeriods"]["$this->elementID"][$x]["elements"][$roomID]["id"] == $id["id"]) {
        
        
                // echo "\n----------------\n";
                // echo "lessonId: ".$base["elementPeriods"]["$this->elementID"][$x]["lessonId"]. "\n";
                // echo "date: ".$base["elementPeriods"]["$this->elementID"][$x]["date"]. "\n";
                // echo "startTime: ".$base["elementPeriods"]["$this->elementID"][$x]["startTime"]. "\n";
                // echo "endTime: ".$base["elementPeriods"]["$this->elementID"][$x]["endTime"]. "\n";
                // echo "elements: ".$base["elementPeriods"]["$this->elementID"][$x]["elements"][2]["id"]. "\n";
         */


        $dtstart = $base["elementPeriods"]["$this->elementID"][$x]["date"];
        $dtstart = $dtstart . " ";
        $dtstart = $dtstart . $base["elementPeriods"]["$this->elementID"][$x]["startTime"];
        $dtstart = substr_replace($dtstart, substr($dtstart, 0, 4) . "-", 0, 4);
        $dtstart = substr_replace($dtstart, substr($dtstart, 0, 7) . "-", 0, 7);
        $dtstart = substr_replace($dtstart, substr($dtstart, 0, -2) . ":", 0, -2);

        $dtend = $base["elementPeriods"]["$this->elementID"][$x]["date"];
        $dtend = $dtend . " ";
        $dtend = $dtend . $base["elementPeriods"]["$this->elementID"][$x]["endTime"];
        $dtend = substr_replace($dtend, substr($dtend, 0, 4) . "-", 0, 4);
        $dtend = substr_replace($dtend, substr($dtend, 0, 7) . "-", 0, 7);
        $dtend = substr_replace($dtend, substr($dtend, 0, -2) . ":", 0, -2);

        //echo "$dtstart - $dtend \n";


        $dtstart = date("Y-m-d H:i:s", strtotime($dtstart));
        $dtend = date("Y-m-d H:i:s", strtotime($dtend));



        $iCalProperties_0 = array(
          "subject" => "$subject",
          "dtstart" => "$dtstart",
          "dtend" => "$dtend",
          "room" => "$room",
          "teacher" => "$teacher"
        );

        $i = count($iCalProperties) + 1;
        //echo $i;
        if ($iCalProperties[0] == array("subject" => "", "dtstart" => "", "dtend" => "", "room" => "", "teacher" => "")) {
          $i = 0;
        }
        $iCalProperties[$i] = $iCalProperties_0;


        //}
      }
    }
    sort($iCalProperties);
    return $iCalProperties;
  }



  function getJSON()
  {
    require 'config.php';
    $conn = new mysqli($DB_HOSTNAME, $DB_USERNAME, $DB_PASSWORD, $DB_NAME);
    try {
      $sessionID = $this->sessionID;
      $stmt = $conn->prepare('SELECT Server,School,User,Password,Client,sessionID,personID, personType, klasseID FROM authenticate WHERE sessionID = ?');
      $stmt->bind_param('s', $sessionID); // 's' specifies the variable type => 'string' 



      $stmt->execute();
      $result = $stmt->get_result();

      if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
          $JSESSIONID = $row["sessionID"];
          $schoolname = $row["School"];
          $server = $row["Server"];
          $this->elementID = $row["personType"];
          $elementType = $row["personID"];
        }
      } else {
        die("Login not found");
      }
      $stmt->close();
      $conn->close();
    } catch (\Exception $e) {
      echo "Error while inserting to database: $e";
    }
    require 'configr.php';



    // Generated by curl-to-PHP: http://incarnate.github.io/curl-to-php/
    $ch = curl_init();
    $date = date("Y-m-d", strtotime($this->date));
    curl_setopt($ch, CURLOPT_URL, "https://$server/WebUntis/api/public/timetable/weekly/data?elementType=$elementType&elementId=$this->elementID&date=$date&formatId=2");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'GET');

    curl_setopt($ch, CURLOPT_ENCODING, 'gzip, deflate');

    $headers = array();
    $headers[] = 'Pragma: no-cache';
    $headers[] = 'Accept-Encoding: gzip, deflate, br';
    $headers[] = 'Accept-Language: de-DE,de;q=0.9,en-US;q=0.8,en;q=0.7';
    $headers[] = 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36 OPR/58.0.3135.68';
    $headers[] = 'Accept: application/json';
    $headers[] = "Referer: https://$server/WebUntis/?school=$schoolname";
    $headers[] = 'Cookie: schoolname="_' . base64_encode($schoolname) . '"; JSESSIONID=' . $JSESSIONID;
    $headers[] = 'Connection: keep-alive';
    $headers[] = 'Cache-Control: no-cache';
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);

    $result = curl_exec($ch);

    if (curl_errno($ch)) {
      echo 'Error:' . curl_error($ch);
    }
    curl_close($ch);

    $this->jsonArray = json_decode($result, true);
  }


  function jsonRequest(string $jsonMethod, array $jsonParams)
  {
    $server = $this->server;
    $school = $this->school;

    $url = "https://$server/WebUntis/jsonrpc.do?school=$school";



    $jsonData = array(
      'id' => $this->jsonID,
      'method' => $jsonMethod,
      'params' => $jsonParams,
      'jsonrpc' => $this->jsonRPC
    );

    $content = json_encode($jsonData);

    $curl = curl_init($url);
    curl_setopt($curl, CURLOPT_HEADER, false);
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
    curl_setopt(
      $curl,
      CURLOPT_HTTPHEADER,
      array("Content-type: application/json")
    );
    curl_setopt($curl, CURLOPT_POST, true);
    curl_setopt($curl, CURLOPT_POSTFIELDS, $content);

    $json_response = curl_exec($curl);

    $status = curl_getinfo($curl, CURLINFO_HTTP_CODE);


    curl_close($curl);

    return json_decode($json_response, true);
  }

  public function authenticate()
  {

    $jsonParamsUser = $this->jsonParamsUser;
    $jsonParamsPassword = $this->jsonParamsPassword;
    $jsonParamsClient = $this->jsonParamsClient;
    $server = $this->server;
    $school = $this->school;

    $jsonParams = array(
      'user' => $jsonParamsUser,
      'password' => $jsonParamsPassword,
      'client' => $jsonParamsClient
    );

    $response = $this->jsonRequest("authenticate", $jsonParams);

    require 'config.php';
    $conn = new mysqli($DB_HOSTNAME, $DB_USERNAME, $DB_PASSWORD, $DB_NAME);
    try {
      $stmt = $conn->prepare('INSERT INTO `authenticate` (`ID`, `Server`, `School`, `User`, `Password`, `Client`, `sessionID`, `personID`, `personType`, `klasseID`) VALUES (NULL, ? , ? , ? , ? , ? , ? , ? , ? , ?)');
      $stmt->bind_param(
        'sssssssss',
        $server,
        $school,
        $jsonParamsUser,
        $jsonParamsPassword,
        $jsonParamsClient,
        $response["result"]["sessionId"],
        $response["result"]["personType"],
        $response["result"]["personId"],
        $response["result"]["klasseId"]
      ); // 's' specifies the variable type => 'string'

      $stmt->execute();


      $stmt->close();
      $conn->close();
      require 'configr.php';
      return $response["result"]["sessionId"];
    } catch (\Exception $e) {
      return "Error while inserting to database: $e";
    }
  }
}
