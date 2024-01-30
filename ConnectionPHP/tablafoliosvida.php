<?php
// Conexión a la base de datos
header("Access-Control-Allow-Origin: *");

//OBTENGO LA VARIABLE $conn
include_once 'conexion.php';

// Iniciar la sesión
session_start();

// Obtener la conexión
$conn = obtenerConexion();

$d_promesar=0;

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
        $fechaPromesa = date('Y-m-d H:i:s', strtotime($row[0]));
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
                            // Verificación de la fecha actual con la fecha de vencimiento para el semáforo
                            $fechaVencimiento = strtotime(date('d-m-Y', $fechaVencimiento));
                            $fechaActual = time();
                            $row['fecha_vencimiento'] = $fechaVencimiento;
                            $row['fecha_actual'] = $fechaActual;

                            // Nuevo fragmento corregido
                            $consulta = "select cd_estado from cam_estado where folio='".$row['id']."'";
                            $resultado = mysqli_query($conn, $consulta);

                            while ($verfecha = mysqli_fetch_row($resultado)) {
                                $datosfecha = $verfecha[0]; //cambio de estado
                                $fechap = strtotime(date("d-m-Y", strtotime($datosfecha))); //formateo de la fecha cambio de estado

                                if ($row['estado'] == "TERMINADO CON POLIZA" || $row['estado'] == "TERMINADO") { //corrección en condiciones

                                    if ($fechaVencimiento > $fechap) {
                                        $row['semaforo'] = 'verde'; //actualización del semáforo
                                    } else if ($fechaVencimiento < $fechap) {
                                        $row['semaforo'] = 'rojo'; //actualización del semáforo
                                    } else if ($fechaVencimiento == $fechap) {
                                        $row['semaforo'] = 'amarillo'; //actualización del semáforo
                                    }
                                    $row['fecha_promesa'] = date('d-m-Y', $fechaVencimiento); // Asegúrate de ajustar el formato si es necesario
                                }
                            }
                        }
                } else {
                    $row['fecha_promesa'] = '***';
                    $row['semaforo'] = '***';
                }
                break;
                case 'PAGOS':
        if ($row['estado'] != 'CANCELADO' && $row['estado'] != 'ENVIADO') {
            $fechaPromesa = obtenerFechaPromesa($conn, $row['id']);
            // Reemplaza la sección del semáforo para PAGOS y MOVIMIENTOS
            if ($fechaPromesa) {
                $dias = $d_promesar; // Ajusta los días según tus requisitos
                $fechaVencimiento = calcularFechaVencimiento($fechaPromesa, $dias, $feriadosAlta);
                $row['fecha_promesa'] = date('d-m-Y', $fechaVencimiento);

                $fechaVencimiento = strtotime(date('d-m-Y', $fechaVencimiento));
                $fechaActual = time();



                // Nuevo fragmento corregido
                $consulta = "select cd_estado from cam_estado where folio='".$row['id']."'";
                $resultado = mysqli_query($conn, $consulta);

                while ($verfecha = mysqli_fetch_row($resultado)) {
                    $datosfecha = $verfecha[0]; //cambio de estado
                    $fechap = strtotime(date("d-m-Y", strtotime($datosfecha))); //formateo de la fecha cambio de estado

                    if ($row['estado'] == "TERMINADO CON POLIZA" || $row['estado'] == "TERMINADO") { //corrección en condiciones

                        if ($fechaVencimiento > $fechap) {
                            $row['semaforo'] = 'verde'; //actualización del semáforo
                        } else if ($fechaVencimiento < $fechap) {
                            $row['semaforo'] = 'rojo'; //actualización del semáforo
                        } else if ($fechaVencimiento == $fechap) {
                            $row['semaforo'] = 'amarillo'; //actualización del semáforo
                        }
                        $row['fecha_promesa'] = date('d-m-Y', $fechaVencimiento); // Asegúrate de ajustar el formato si es necesario
                    }
                }
                // Fin del nuevo fragmento
            }
        } else {
            $row['fecha_promesa'] = '***';
            $row['semaforo'] = '***';
        }
        break;
            case 'MOVIMIENTOS':
                if ($row['estado'] != 'CANCELADO' && $row['estado'] != 'ENVIADO') {
                    $sqlr = "select * from producto where producto='" . $row['producto'] . "'";
                    $resr = mysqli_query($conn, $sqlr);
                    while ($verr = mysqli_fetch_row($resr)) {
                        $d_promesar = $verr[3];
                    }
                    $fechaPromesa = obtenerFechaPromesa($conn, $row['id']);
                        if ($fechaPromesa) {
                            $dias = $d_promesar; // Ajusta los días según tus requisitos
                            $fechaVencimiento = calcularFechaVencimiento($fechaPromesa, $dias, $feriadosAlta);
                            $row['fecha_promesa'] = date('d-m-Y', $fechaVencimiento);
                        }
                        $fechaVencimiento = strtotime(date('d-m-Y', $fechaVencimiento));
                        $fechaActual = time();

                         // Nuevo fragmento corregido
                         $consulta = "select cd_estado from cam_estado where folio='".$row['id']."'";
                         $resultado = mysqli_query($conn, $consulta);

                         while ($verfecha = mysqli_fetch_row($resultado)) {
                             $datosfecha = $verfecha[0]; //cambio de estado
                             $fechap = strtotime(date("d-m-Y", strtotime($datosfecha))); //formateo de la fecha cambio de estado

                             if ($row['estado'] == "TERMINADO CON POLIZA" || $row['estado'] == "TERMINADO") { //corrección en condiciones

                                 if ($fechaVencimiento > $fechap) {
                                     $row['semaforo'] = 'verde'; //actualización del semáforo
                                 } else if ($fechaVencimiento < $fechap) {
                                     $row['semaforo'] = 'rojo'; //actualización del semáforo
                                 } else if ($fechaVencimiento == $fechap) {
                                     $row['semaforo'] = 'amarillo'; //actualización del semáforo
                                 }
                                 $row['fecha_promesa'] = date('d-m-Y', $fechaVencimiento); // Asegúrate de ajustar el formato si es necesario
                             }
                         }
                } else {
                    $row['fecha_promesa'] = '***';
                    $row['semaforo'] = '***';
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
