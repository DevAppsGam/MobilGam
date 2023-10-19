<?php
// Conexión a la base de datos
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "gamse627_ventanasis";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
}

$feriadosAlta = array(
    '2019-01-01','2019-02-04','2019-03-18','2019-04-18','2019-04-19','2019-05-01','2019-05-10','2019-09-16','2019-11-18','2019-12-12',
    '2019-12-25','2019-12-31','2020-01-01','2020-02-03','2020-03-16','2020-04-09','2020-04-10','2020-05-01','2020-09-16','2020-11-16',
    '2020-12-25','2021-01-01','2021-02-01','2021-03-15','2021-04-08','2021-04-09','2021-09-16','2021-11-15','2022-02-07','2022-03-21',
    '2022-04-14','2022-04-15','2022-09-16','2022-11-01','2022-11-02','2022-10-21','2023-02-06','2023-03-20','2023-04-06','2023-04-07',
    '2023-05-01','2023-05-05','2023-05-10','2023-09-16','2023-11-01','2023-11-02','2023-11-20','2023-12-12','2023-12-25',
);

$feriadosAlta = array_flip($feriadosAlta);

function obtenerFechaPromesa($conexion, $folio){
    $sql = "SELECT fechaest FROM promesa WHERE folio=?";
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

function calcularFechaVencimiento($fecha, $dias, $feriadosAlta){
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



$nombreUsuario = isset($_GET['username']) ? $_GET['username'] : '';

$sqlu = "SELECT id FROM datos_agente WHERE nomusuario = '$nombreUsuario'";
$resultu = $conn->query($sqlu);

if ($resultu->num_rows > 0) {
    $row = $resultu->fetch_assoc();
    $idAgente = $row['id'];
} else {
    exit;
}

$filter = isset($_GET['filter']) ? $_GET['filter'] : '';
$filtersArray = explode(',', $filter);

$sql = "SELECT * FROM folios WHERE id_agente = $idAgente AND t_solicitud IN ('ALTA DE POLIZA', 'MOVIMIENTOS', 'PAGOS')";

$validFilters = array(
    'ALTA DE POLIZA',
    'PAGOS',
    'MOVIMIENTOS',
    'a_tiempo',
    'por_vencer',
    'vencidos'
);

if (!empty($filtersArray)) {
    $filterConditions = array();
    foreach ($filtersArray as $filterItem) {
        if (in_array($filterItem, $validFilters)) {
            $filterConditions[] = "t_solicitud = '$filterItem'";
        }
    }

    if (!empty($filterConditions)) {
        $sql .= " AND (" . implode(" OR ", $filterConditions) . ")";
    }
}

$sql .= " ORDER BY fecha DESC";
$result = $conn->query($sql);

$response = array();

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        foreach ($row as $key => $value) {
            if ($value === null || $value === '' || strtolower($value) === 'null') {
                $row[$key] = '***';
            }
        }

        switch ($row['t_solicitud']) {
            case 'ALTA DE POLIZA':
                if ($row['estado'] != 'CANCELADO' && $row['estado'] != 'ENVIADO') {
                    $sqlr = "select * from rango where tiporan='" . $row['rango'] . "'";
                    $resr = mysqli_query($conn, $sqlr);
                    while ($verr = mysqli_fetch_row($resr)) {
                        $d_promesar = $verr[2];
                    }
                    $fechaPromesa = obtenerFechaPromesa($conn, $row['id']);
                        if ($fechaPromesa) {
                            $dias = $d_promesar; // Ajusta los días según tus requisitos
                            $fechaVencimiento = calcularFechaVencimiento($fechaPromesa, $dias, $feriadosAlta);
                            $row['fecha_promesa'] = date('d-m-Y', $fechaVencimiento);
                        }
                } else {
                    $row['fecha_promesa'] = '***';
                }
                break;
                case 'PAGOS':
                    if ($row['estado'] != 'CANCELADO' && $row['estado'] != 'ENVIADO') {
                        $fechaPromesa = obtenerFechaPromesa($conn, $row['id']);
                        if ($fechaPromesa) {
                            $dias = 1; // Ajusta los días según tus requisitos
                            $fechaVencimiento = calcularFechaVencimiento($fechaPromesa, $dias, $feriadosAlta);
                            $row['fecha_promesa'] = date('d-m-Y', $fechaVencimiento);
                        }
                    } else {
                        $row['fecha_promesa'] = '***';
                    }
                    break;
            case 'MOVIMIENTOS':
                if ($row['estado'] != 'CANCELADO' && $row['estado'] != 'ENVIADO') {

                } else {
                    $row['fecha_promesa'] = '***';
                }
                break;
            default:
                $row['fecha_promesa'] = '***';
        }
        $response[] = $row;
    }
}

$conn->close();

header('Content-Type: application/json');
echo json_encode($response);
?>
