<?php
session_start();
// Conexión a la base de datos
$servername = "localhost"; // Cambiar si es necesario
$username = "root"; // Cambiar por el nombre de usuario de tu base de datos
$password = ""; // Cambiar por la contraseña de tu base de datos
$dbname = "gamse627_ventanasis"; // Cambiar por el nombre de tu base de datos


// Función para verificar las credenciales del usuario
function verificarCredenciales($conn, $username, $password) {
    $stmt = $conn->prepare("SELECT nomusuario, password, id_tipo_usuario, id FROM datos_agente WHERE nomusuario = ?");
    $stmt->bind_param("s", $username);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $dbPasswordHash = $row["password"];
        if (hash("sha512", $password) === $dbPasswordHash) {
            return $row;
        }
    }

    return null;
}

// Main code
try {
    $conn = new mysqli($servername, $username, $password, $dbname);

    if ($conn->connect_error) {
        throw new Exception("Conexión fallida: " . $conn->connect_error);
    }

    // Obtener las credenciales del cliente (Flutter)
    $username = mysqli_real_escape_string($conn, $_POST["nomusuario"]);
    $password = mysqli_real_escape_string($conn, $_POST["password"]);

    $userData = verificarCredenciales($conn, $username, $password);

    if ($userData !== null) {
        $_SESSION["id"] = $userData["id"];
        $response = [
            "success" => true,
            "message" => "Inicio de sesión exitoso",
            "nomusuario" => $userData["nomusuario"],
            "tipo" => $userData["id_tipo_usuario"],
            "id" => $userData["id"]
        ];
    } else {
        $response = ["error" => "Usuario y/o contraseña incorrecto, vuelva a intentar"];
    }

    // Cerrar la conexión a la base de datos
    $conn->close();

} catch (Exception $e) {
    $response = ["error" => "Error en el servidor: " . $e->getMessage()];
}

// Devolver la respuesta en formato JSON al cliente (Flutter)
header('Content-Type: application/json');
echo json_encode($response);
?>
