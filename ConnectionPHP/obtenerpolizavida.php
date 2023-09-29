<?php
// Conexión a la base de datos
$servername = "localhost"; // Cambiar si es necesario
$username = "root"; // Cambiar por el nombre de usuario de tu base de datos
$password = ""; // Cambiar por la contraseña de tu base de datos
$dbname = "gamse627_ventanasis"; // Cambiar por el nombre de tu base de datos

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
}

// Consulta para contar los registros con estado "TERMINADO"
$sqlTerminado = "SELECT COUNT(*) as totalTerminado FROM folios WHERE estado = 'TERMINADO'";
$resultTerminado = $conn->query($sqlTerminado);

$response = array();

if ($resultTerminado->num_rows > 0) {
    while ($row = $resultTerminado->fetch_assoc()) {
        $response["totalTerminado"] = intval($row["totalTerminado"]); // Convertir a entero
    }
} else {
    $response["totalTerminado"] = 0;
}

// Consulta para contar los registros con estado "TERMINADO CON POLIZA"
$sqlTerminadoConPoliza = "SELECT COUNT(*) as totalTerminadoConPoliza FROM folios WHERE estado = 'TERMINADO CON POLIZA'";
$resultTerminadoConPoliza = $conn->query($sqlTerminadoConPoliza);

if ($resultTerminadoConPoliza->num_rows > 0) {
    while ($row = $resultTerminadoConPoliza->fetch_assoc()) {
        $response["totalTerminadoConPoliza"] = intval($row["totalTerminadoConPoliza"]); // Convertir a entero
    }
} else {
    $response["totalTerminadoConPoliza"] = 0;
}

// Cerrar la conexión a la base de datos
$conn->close();

// Devolver la respuesta en formato JSON al cliente (Flutter)
header('Content-Type: application/json');
echo json_encode($response);
?>
