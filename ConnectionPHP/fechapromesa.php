<?php
session_start();
// Conexión a la base de datos
$servername = "localhost"; // Cambiar si es necesario
$username = "root"; // Cambiar por el nombre de usuario de tu base de datos
$password = ""; // Cambiar por la contraseña de tu base de datos
$dbname = "gamse627_ventanasis"; // Cambiar por el nombre de tu base de datos

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
}

$folioSelec = isset($_GET['id']) ? $_GET['id'] : '';

$feriados = array(
    '2019-01-01','2019-02-04','2019-03-18','2019-04-18','2019-04-19','2019-05-01','2019-05-10','2019-09-16','2019-11-18','2019-12-12',
    '2019-12-25','2019-12-31','2020-01-01','2020-02-03','2020-03-16','2020-04-09','2020-04-10','2020-05-01','2020-09-16','2020-11-16',
    '2020-12-25','2021-01-01','2021-02-01','2021-03-15','2021-04-08','2021-04-09','2021-09-16','2021-11-15','2022-02-07','2022-03-21',
    '2022-04-14','2022-04-15','2022-09-16','2022-11-01','2022-11-02','2022-10-21','2023-02-06','2023-03-20','2023-04-06','2023-04-07',
    '2023-05-01','2023-05-05','2023-05-10','2023-09-16','2023-11-01','2023-11-02','2023-11-20','2023-12-12','2023-12-25',
);

$feriados = array_flip($feriados);

function obtenerFechaPromesa($conexion, $folio)
{
    $sql = "SELECT fechaest FROM promesa WHERE folio?";
    $stmt = mysqli_prepare($conexion, $sql);
    mysqli_stmt_bind_param($stmt, "s", $folio);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);
    $fechaPromesa = null;
    if ($row = mysqli_fetch_row($result)) {
        $fechaPromesa = $row[0];
    }
    mysqli_stmt_close($stmt);
    return $fechaPromesa;
}

function calcularFechaVencimiento($fecha, $dias, $feriados)
{
    $fechaUnix = strtotime($fecha); // Convierte la fecha en formato Unix
    $fechaVencimiento = $fechaUnix;

    $i = 0;
    while ($i < $dias) {
        $fechaVencimiento += 86400; // Agrega un día en segundos
        $esFeriado = isset($feriados[date('Y-m-d', $fechaVencimiento)]);

        if (!(date('w', $fechaVencimiento) == 6 || date('w', $fechaVencimiento) == 0 || $esFeriado)) {
            $i++;
        }
    }

    return $fechaVencimiento;
}


if ($folioSelec) {
    $fechaPromesa = obtenerFechaPromesa($conn, $folioSelec);
    if ($fechaPromesa) {
        $dias = 1;
        $fechaVencimiento = calcularFechaVencimiento($fechaPromesa, $dias, $feriados);
        $fechaVencimientoFormato = date('d-m-Y', $fechaVencimiento);
        echo $fechaVencimientoFormato; // Mostrar la fecha de vencimiento
    }
}

// Cerrar la conexión a la base de datos
$conn->close();
?>