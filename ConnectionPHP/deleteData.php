<?php
include 'conexion.php';
$id=$_POST['id'];
$connect->query("DELETE FROM users WHERE id=".$id");
?>