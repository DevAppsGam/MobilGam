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

$response = array();

//CONSULTA TABLA folios en 2022
$sql = "SELECT COUNT(*) AS tvida FROM folios WHERE estado = 'TERMINADO CON POLIZA' AND YEAR(fecha) = 2022";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        // Convertir el valor de 'total' a tipo numérico
        $row['tvida'] = intval($row['tvida']);
        $response['tvida'] = $row['tvida'];
    }
} else {
    $response['tvida'] = 0;
}

//CONSULTA TABLA folios_a en 2022
$sql2 = "SELECT COUNT(*) AS tautos FROM folios_a WHERE estado = 'TERMINADO' AND YEAR(fecha) = 2022";
$result2 = $conn->query($sql2);

if ($result2->num_rows > 0) {
    while ($row = $result2->fetch_assoc()) {
        // Convertir el valor de 'total' a tipo numérico
        $row['tautos'] = intval($row['tautos']);
        $response['tautos'] = $row['tautos'];
    }
} else {
    $response['tautos'] = 0;
}

//CONSULTA TABLA folios_g en 2022
$sql3 = "SELECT COUNT(*) AS tgmm FROM folios_g WHERE estado = 'TERMINADO CON POLIZA' AND YEAR(fecha) = 2022";
$result3 = $conn->query($sql3);

if ($result3->num_rows > 0) {
    while ($row = $result3->fetch_assoc()) {
        // Convertir el valor de 'total' a tipo numérico
        $row['tgmm'] = intval($row['tgmm']);
        $response['tgmm'] = $row['tgmm'];
    }
} else {
    $response['tgmm'] = 0;
}

//CONSULTA TABLA folios_s en 2022
$sql4 = "SELECT COUNT(*) AS ts FROM folios_s WHERE estado = 'TERMINADO' AND YEAR(fecha) = 2022";
$result4 = $conn->query($sql4);

if ($result4->num_rows > 0) {
    while ($row = $result4->fetch_assoc()) {
        // Convertir el valor de 'total' a tipo numérico
        $row['ts'] = intval($row['ts']);
        $response['ts'] = $row['ts'];
    }
} else {
    $response['ts'] = 0;
}

// Cerrar la conexión a la base de datos
$conn->close();

// Devolver la respuesta en formato JSON al cliente (Flutter)
header('Content-Type: application/json');
echo json_encode($response);
?>
