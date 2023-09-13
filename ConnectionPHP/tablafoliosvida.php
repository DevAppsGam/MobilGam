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

$nombreUsuario = isset($_GET['username']) ? $_GET['username'] : '';

// Consulta el id del agente correspondiente al nombreUsuario
$sqlu = "SELECT id FROM datos_agente WHERE nomusuario = '$nombreUsuario'";

// Ejecuta la consulta SQL
$resultu = $conn->query($sqlu);

// Verifica si se encontró un resultado
if ($resultu->num_rows > 0) {
    $row = $resultu->fetch_assoc();
    $idAgente = $row['id']; // Almacena el id del agente en una variable
} else {
    // El nombre de usuario no se encontró en la tabla datos_agente
    echo "El nombre de usuario '$nombreUsuario' no existe.";
    exit; // Sale del script PHP
}

// Obtener el parámetro de filtro de la URL
$filter = isset($_GET['filter']) ? $_GET['filter'] : '';

// Divide el parámetro de filtro en un array utilizando la coma como separador
$filtersArray = explode(',', $filter);

$sql = "SELECT * FROM folios WHERE id >= 20000 AND id_agente = $idAgente";

// Define un array de filtros válidos
$validFilters = array(
    'ALTA DE POLIZA',
    'PAGOS',
    'MOVIMIENTOS',
    'a_tiempo',
    'por_vencer',
    'vencidos'
);

// Verifica si se enviaron múltiples filtros
if (!empty($filtersArray)) {
    $filterConditions = array();
    foreach ($filtersArray as $filterItem) {
        // Verifica si cada filtro es válido y construye las condiciones
        if (in_array($filterItem, $validFilters)) {
            $filterConditions[] = "t_solicitud = '$filterItem'";
        }
    }

    // Combina las condiciones con "OR" y agrega al SQL si hay al menos una condición válida
    if (!empty($filterConditions)) {
        $sql .= " AND (" . implode(" OR ", $filterConditions) . ")";
    }
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
