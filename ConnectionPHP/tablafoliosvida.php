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

// Agrega condiciones según el filtro proporcionado
if ($filter == 'alta_de_poliza') {
    $sql .= " AND t_solicitud = 'ALTA DE POLIZA'";
} elseif ($filter == 'pagos') {
    $sql .= " AND t_solicitud = 'PAGOS'";
} elseif ($filter == 'movimientos') {
    $sql .= " AND t_solicitud = 'MOVIMIENTOS'";
} elseif ($filter == 'a_tiempo') {
    $sql .= " AND t_solicitud = 'A TIEMPO'";
} elseif ($filter == 'por_vencer') {
    $sql .= " AND t_solicitud = 'POR VENCER'";
} elseif ($filter == 'vencidos') {
    $sql .= " AND t_solicitud = 'VENCIDOS'";
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
