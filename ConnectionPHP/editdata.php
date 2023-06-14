<?php
include 'conexion.php';

$id=$_POST['id'];
$username=$_POST['username'];
$password=$_POST['password'];
$tipo=$_POST['tipo'];

$connect->query("UPDATE users SET username='".$username."', password='".$password."', tipo='".$tipo."' WHERE id='".$id."'");
?>