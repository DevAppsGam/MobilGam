<?php

require_once 'conexion.php';

// Obtén el nombre de usuario y la contraseña de la solicitud
$username = $_POST['username'];
$password = $_POST['password'];

// Escapa los valores de usuario y contraseña para evitar inyección de SQL
$escapedUsername = $connect->real_escape_string($username);
$escapedPassword = $connect->real_escape_string($password);

// Consulta la base de datos para verificar la autenticación del usuario
$query = "SELECT * FROM users WHERE username = '$escapedUsername' AND password = '$escapedPassword'";
$result = $connect->query($query);

// Comprueba si se encontró un registro coincidente en la base de datos
if ($result->num_rows > 0) {
    // Obtiene los datos del usuario
    $userData = $result->fetch_assoc();
    $userType = $userData['tipo']; // Asegúrate de que 'tipo' sea el nombre correcto de la columna que almacena el tipo de usuario

    // Define los roles y redirecciona según el tipo de usuario
    switch ($userType) {
        case 'admin':
            $responseData = array('tipo' => 'admin');
            break;
        case 'gdd':
            $responseData = array('tipo' => 'gdd');
            break;
        case 'agente':
            $responseData = array('tipo' => 'agente');
            break;
        case 'operaciones':
            $responseData = array('tipo' => 'operaciones');
            break;
        case 'promocion':
            $responseData = array('tipo' => 'promocion');
            break;
        default:
            $responseData = array('error' => 'Tipo de usuario desconocido');
            break;
    }
} else {
    // Autenticación fallida, devuelve un mensaje de error
    $responseData = array('error' => 'Usuario o contraseña incorrectos');
}

// Cierra la conexión a la base de datos
$connect->close();

// Establece las cabeceras de respuesta para indicar que el contenido es JSON
header('Content-Type: application/json');

// Envía la respuesta en formato JSON
echo json_encode($responseData);
?>
