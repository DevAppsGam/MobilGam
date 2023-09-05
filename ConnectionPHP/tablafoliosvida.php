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

// Obtén el parámetro de filtro de la URL
$filter = isset($_GET['filter']) ? $_GET['filter'] : '';

// Define una consulta SQL base
$sql = "SELECT * FROM folios WHERE id > 20000";

// Define un array de filtros válidos
$validFilters = array(
    'ALTA DE POLIZA',
    'PAGOS',
    'MOVIMIENTOS',
    'a_tiempo',
    'por_vencer',
    'vencidos'
);

// Verifica si el filtro proporcionado es válido
if (!empty($filter) && in_array($filter, $validFilters)) {
    $sql .= " AND t_solicitud = '$filter'";
}

// Ejecuta la consulta SQL modificada
$result = $conn->query($sql);

$response = array();

if ($result->num_rows > 0) {
    // Recorrer los resultados y almacenarlos en el arreglo de respuesta
    while ($row = $result->fetch_assoc()) {
        $response[] = $row;
    }
}

// Cerrar la conexión a la base de datos
$conn->close();

// Devolver la respuesta en formato JSON al cliente (Flutter)
header('Content-Type: application/json');
echo json_encode($response);
?>
