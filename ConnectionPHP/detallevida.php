<?php
session_start();
// Conexión a la base de datos
$servername = "localhost"; // Cambiar si es necesario
$username = "root"; // Cambiar por el nombre de usuario de tu base de datos
$password = ""; // Cambiar por la contraseña de tu base de datos
$dbname = "gamse627_ventanasis"; // Cambiar por el nombre de tu base de datos

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
}

$folioSelec = isset($_GET['id']) ? $_GET['id'] : '';

// Consulta el id del agente correspondiente al nombreUsuario
$sql = "SELECT id, negocio, DATE(fecha) AS fecha, estado, contratante,producto, poliza, polizap, t_solicitud, monto, moneda_pagos, prioridad, comentarios, movimiento, fgnp, monedap, rango, prima FROM folios WHERE id = $folioSelec";

// Ejecuta la consulta SQL
$result = $conn->query($sql);

$response = array();

if ($result->num_rows > 0) {
    // Recorrer los resultados y almacenarlos en el arreglo de respuesta
    while ($row = $result->fetch_assoc()) {
        // Reemplaza valores nulos o vacíos por "***"
        foreach ($row as $key => $value) {
            if ($value === null || $value === '' || strtolower($value) === 'null') {
                $row[$key] = '***';
            }
        }
        $response[] = $row;
    }
    // Ordena los comentarios por fecha en orden descendente (los más recientes primero)
    usort($response, function($a, $b) {
        return strtotime($b['fecha']) - strtotime($a['fecha']);
    });
}

// Cerrar la conexión a la base de datos
$conn->close();

// Devolver la respuesta en formato JSON al cliente (Flutter)
header('Content-Type: application/json');
echo json_encode($response);
?>