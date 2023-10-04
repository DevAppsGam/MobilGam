<?php
// Conexión a la base de datos
$servername = "localhost"; // Cambiar si es necesario
$username = "root"; // Cambiar por el nombre de usuario de tu base de datos
$password = ""; // Cambiar por la contraseña de tu base de datos
$dbname = "gamse627_ventanasis";

$conn = new mysqli($servername, $username, $password, $database);

if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
}

// Obtener la observación enviada desde Flutter
$observacion = $_POST['observacion'];

// Insertar la observación en la base de datos
$sql = "INSERT INTO comentarios (comentario) VALUES ('$observacion')";

if ($conn->query($sql) === TRUE) {
    echo "Observación insertada correctamente";
} else {
    echo "Error al insertar la observación: " . $conn->error;
}

$conn->close();
?>
