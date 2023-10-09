<?php
// Conexión a la base de datos
$servername = "localhost"; // Cambiar si es necesario
$username = "root"; // Cambiar por el nombre de usuario de tu base de datos
$password = ""; // Cambiar por la contraseña de tu base de datos
$dbname = "gamse627_ventanasis";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
}

// Obtener la observación y el id enviados desde Flutter
$id = isset($_GET['id']) ? $_GET['id'] : '';
$observacion = isset($_GET['observacion']) ? strtoupper($_GET['observacion']) : '';

// Consultar el estado en la tabla folios
$sqlestado = "SELECT estado FROM folios WHERE id='$id'";
$resultado = $conn->query($sqlestado);

if ($resultado->num_rows > 0) {
    $fila = $resultado->fetch_assoc();
    $estado = $fila['estado'];
} else {
    $estado = '***'; // Si no se encuentra un estado, puedes asignar un valor predeterminado aquí.
}

// Consultar el estado en la tabla folios
$sqlusuario = "SELECT id_agente FROM folios WHERE id='$id'";
$resultado = $conn->query($sqlusuario);

if ($resultado->num_rows > 0) {
    $fila = $resultado->fetch_assoc();
    $id_agente = $fila['id_agente'];
} else {
    $id_agente = '***'; // Si no se encuentra un estado, puedes asignar un valor predeterminado aquí.
}

// Consultar el estado en la tabla folios
$sqlusername = "SELECT nomusuario FROM datos_agente WHERE id='$id_agente'";
$resultado = $conn->query($sqlusername);

if ($resultado->num_rows > 0) {
    $fila = $resultado->fetch_assoc();
    $user = $fila['nomusuario'];
} else {
    $user = '***'; // Si no se encuentra un estado, puedes asignar un valor predeterminado aquí.
}

// Obtener la fecha actual
$fechaActual = date("Y-m-d H:i:s"); // Formato: Año-Mes-Día

// Insertar la observación en la base de datos junto con la fecha actual
$sql = "INSERT INTO comentarios (comentario, folio, estado1, usuario, fecha_comentario) VALUES ('$observacion', '$id', '$estado', '$user', '$fechaActual')";

if ($conn->query($sql) === TRUE) {
    echo "Observación insertada correctamente";
} else {
    echo "Error al insertar la observación: " . $conn->error;
}

$conn->close();
?>
