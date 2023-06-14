<?php
include 'conexion.php';

$username=$_POST["username"];
$password=$_POST["password"];
$consultar=$connect->query("SELECT * FROM users WHERE username = '".$username."' and password = '".$password."' ");
$result=array();

while($extraerDatos=$queryResult->fetch_assoc()){
    $result[]=$extraerDatos;
}
echo json_encode($result);
?>