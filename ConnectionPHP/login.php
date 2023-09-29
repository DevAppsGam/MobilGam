<?php
error_log("Username: $username, Password: $password");

// Conexión a la base de datos
$servername = "localhost"; // Cambiar si es necesario
$username = "root"; // Cambiar por el nombre de usuario de tu base de datos
$password = "root"; // Cambiar por la contraseña de tu base de datos
$dbname = "gamse627_ventanasis"; // Cambiar por el nombre de tu base de datos

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
}

// Obtener las credenciales del cliente (Flutter)
$username = $_POST["nomusuario"];
$password = $_POST["password"];

// Realizar la consulta en la tabla "datos_agente"
$stmt = $conn->prepare("SELECT nomusuario, password, id_tipo_usuario FROM datos_agente WHERE nomusuario = ?");
$stmt->bind_param("s", $username);
$stmt->execute();
$result = $stmt->get_result();

// Crear una respuesta por defecto
$response = ["error" => "Usuario o contrasena incorrecta"];

// Verificar si se encontraron registros en la tabla
if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $dbPasswordHash = $row["password"];

    // Verificar si la contraseña enviada coincide con el hash almacenado en la base de datos
    if (hash("sha512", $password) === $dbPasswordHash) {
        // Si la contraseña coincide, devolver los datos del usuario (incluyendo el tipo) en formato JSON
        $response["nomusuario"] = $row["nomusuario"];
        $response["tipo"] = $row["id_tipo_usuario"];
        unset($response["error"]); // Eliminar el mensaje de error
    }
}

// Cerrar la conexión a la base de datos
$stmt->close();
$conn->close();

// Devolver la respuesta en formato JSON al cliente (Flutter)
header('Content-Type: application/json');
echo json_encode($response);
?>