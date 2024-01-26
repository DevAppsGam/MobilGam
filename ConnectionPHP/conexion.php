<?php
$servername = "localhost";
$username = "gamse627_sis780";
$password = "Voltech55";
$database = "gamse627_pruebasistemas";

function obtenerConexion() {
    global $servername, $username, $password, $database;
    $conn = new mysqli($servername, $username, $password, $database);

    if ($conn->connect_error) {
        die("ConexiOn fallida: " . $conn->connect_error);
    }

    return $conn;
}
?>
