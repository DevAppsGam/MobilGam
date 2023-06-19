
<?php
include 'conexion.php';

$username = $_POST["username"] ?? '';
$password = $_POST["password"] ?? '';

// Verificar si se proporcionaron tanto el nombre de usuario como la contraseña
if ($username && $password) {
    // Consulta preparada para evitar la inyección SQL
    $query = $connect->prepare("SELECT * FROM users WHERE username = ? AND password = ?");
    $query->bind_param("ss", $username, $password);
    $query->execute();

    // Obtener resultados
    $result = $query->get_result();
    $datauser = $result->fetch_assoc();

    if ($datauser) {
        echo json_encode($datauser);
    } else {
        // Usuario o contraseña incorrectos
        echo json_encode([]);
    }
} else {
    // Usuario o contraseña no proporcionados
    echo "\nNO RECIBI USUARIO NI CONTRASEÑA\n";
    echo json_encode([]);
}
?>
