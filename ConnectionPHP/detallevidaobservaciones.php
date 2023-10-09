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
$sql = "SELECT fecha_comentario, comentario, usuario, estado1 FROM comentarios WHERE folio = $folioSelec ORDER BY fecha_comentario desc";

// Ejecuta la consulta SQL
$result = $conn->query($sql);

$response = array();

if ($result->num_rows > 0) {
    // Recorrer los resultados y almacenarlos en el arreglo de respuesta
    while ($row = $result->fetch_assoc()) {
        // Reemplaza valores nulos o vacíos por "***"
        foreach ($row as $key => $value) {
            if ($value === null || $value === '') {
                $row[$key] = '***';
            }
        }
        $response[] = $row;
    }
}

// Cerrar la conexión a la base de datos
$conn->close();

// Devolver la respuesta en formato JSON al cliente (Flutter)
header('Content-Type: application/json');
echo json_encode($response);
?>