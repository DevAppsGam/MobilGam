<?php
include 'conexion.php';
$username=$_POST["username"];
$password=$_POST["password"];
$tipo=$_POST["tipo"];

$connect->query("INSERT INTO users (username,password,tipo) VALUES('".$username."','".$password."','".$tipo."')");
?>