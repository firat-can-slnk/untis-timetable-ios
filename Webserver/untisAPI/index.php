
<?php
require_once("vendor/autoload.php");

use Webuntis\Configuration\WebuntisConfiguration;
use Webuntis\Query\Query;

$server = $_GET["server"];
$school = $_GET["school"];
$username = $_GET["username"];
$password = $_GET["password"];
$module = $_GET["module"];

$configname = $server.$school.$username.$password;

$config = new WebuntisConfiguration([
"default" => [
       //f.e. thalia, cissa etc.
        'server' => $server,
        'school' => $school,
        'username' => $username,
        'password' => $password
    ],
  "admin" => [
         //f.e. thalia, cissa etc.
          'server' => $server,
          'school' => $school,
          'username' => $username,
          'password' => $password
      ]
 ]);

$query = new Query();
print_r($query->get("$module")->findAll());
?>
