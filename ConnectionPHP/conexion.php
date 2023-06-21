<?php

$host = "localhost";
$username = "root";
$password = "";
$database = "gamusers";

$connect = new mysqli($host, $username, $password, $database);

if ($connect->connect_error) {
    die("Error de conexión: " . $connect->connect_error);
}
