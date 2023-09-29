<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

$servername = "localhost";
$username = "root";
$password = "root";
$database = "gamse627_ventanasis";

// Crear la conexión
$conn = new mysqli($servername, $username, $password, $database);

// Verificar la conexión
if ($conn->connect_error) {
    die("Error de conexión: " . $conn->connect_error);
}

// Realizar la consulta en la tabla "datos_operativos"
$stmt = $conn->prepare("SELECT nomusuario, telefono, extension, correo FROM datos_operativos");
$stmt->execute();
$result = $stmt->get_result();

// Obtener los datos como un arreglo asociativo
$data = array();
while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

// Cerrar el statement
$stmt->close();

// Cerrar la conexión
$conn->close();

// Convertir el arreglo asociativo a JSON
echo json_encode($data);
?>
