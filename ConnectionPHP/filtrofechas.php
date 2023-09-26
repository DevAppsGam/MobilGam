<?php
$servername = "localhost"; // Cambiar si es necesario
$username = "root"; // Cambiar por el nombre de usuario de tu base de datos
$password = ""; // Cambiar por la contraseña de tu base de datos
$dbname = "gamse627_ventanasis"; // Cambiar por el nombre de tu base de datos

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
}

// Consulta el id del agente correspondiente al nombreUsuario
$sql = "SELECT * FROM folios WHERE id_agente=16 AND id > 20000 ORDER BY fecha DESC";

// Ejecuta la consulta SQL
$result = $conn->query($sql);

// Inicializar arrays para almacenar fechas
$fechas_a_tiempo = array();
$fechas_por_vencerse = array();
$fechas_vencidas = array();
$fechas_no_calculadas = array();

// Iterar a través de las filas y almacenar cada fila en el array $datos
$datos = array(); // Inicializa un array para almacenar los resultados

while ($ver = mysqli_fetch_row($result)) {
    // Agrega la fila actual al array $datos
    $datos[] = $ver;

    // Aquí puedes realizar cualquier procesamiento necesario en $ver
    // sin necesidad de convertirlo a una cadena

    //fecha inicio
    // Procesamiento de fechas en función de $ver[14]
    if ($ver[14] == "PROCESO" || $ver[14] == "REPROCESO" || $ver[14] == "TERMINADO" || $ver[14] == "TERMINADO CON POLIZA" || $ver[14] == "ACTIVADO GNP" || $ver[14] == "ACTIVADO MED" || $ver[14] == "ACTIVADO FLT") {
        $sqlpr = "SELECT fechaest FROM promesa WHERE folio='$ver[0]'";
        $resultpr = mysqli_query($conn, $sqlpr);
        while ($verpr = mysqli_fetch_row($resultpr)) {
            $fechaot = $verpr[0];
            $fechapr1 = new DateTime($fechaot);

            // Imprime la fecha procesada
            // echo $fechapr1->format("d-m-Y") . "<br>";
        }
    } else {
        // Imprime un mensaje alternativo
        //echo "***<br>";
    }

    //fecha promesa
    if ($ver[3] == 'PAGOS') {
        if ($ver[14] == 'CANCELADO' or $ver[14] == 'ENVIADO') {
            echo 'NO PUEDE CALCULARSE';
        } else {
            $sqlf = "select fechaest from promesa where folio='$ver[0]'";
            $resultf = mysqli_query($conn, $sqlf);

            while ($verf = mysqli_fetch_row($resultf)) {
                $fecha = $verf[0];
                $dias = 1;

                $feriados = array(
                    '2019-01-01',
                    '2019-02-04',
                    '2019-03-18',
                    '2019-04-18',
                    '2019-04-19',
                    '2019-05-01',
                    '2019-05-10',
                    '2019-09-16',
                    '2019-11-18',
                    '2019-12-12',
                    '2019-12-25',
                    '2019-12-31',
                    '2020-01-01',
                    '2020-02-03',
                    '2020-03-16',
                    '2020-04-09',
                    '2020-04-10',
                    '2020-05-01',
                    '2020-09-16',
                    '2020-11-16',
                    '2020-12-25',
                    '2021-01-01',
                    '2021-02-01',
                    '2021-03-15',
                    '2021-04-08',
                    '2021-04-09',
                    '2021-09-16',
                    '2021-11-15',
                    '2022-02-07',
                    '2022-03-21',
                    '2022-04-14',
                    '2022-04-15',
                    '2022-09-16',
                    '2022-11-01',
                    '2022-11-02',
                    '2022-10-21',
                    '2023-02-06',
                    '2023-03-20',
                    '2023-04-06',
                    '2023-04-07',
                    '2023-05-01',
                    '2023-05-05',
                    '2023-05-10',
                    '2023-09-16',
                    '2023-11-01',
                    '2023-11-02',
                    '2023-11-20',
                    '2023-12-12',
                    '2023-12-25',
                );


                $comienzo = strtotime($fecha);
                $fecha_venci_noti = $comienzo;
                $i = 0;

                while ($i < $dias) {
                    $fecha_venci_noti += 86400;
                    $es_feriado = FALSE;

                    foreach ($feriados as $key => $feriado) {
                        if (date("Y-m-d", $fecha_venci_noti) === date("Y-m-d", strtotime($feriado))) {
                            $es_feriado = TRUE;
                        }
                    }

                    if (!(date("w", $fecha_venci_noti) == 6 || date("w", $fecha_venci_noti) == 0 || $es_feriado)) {
                        $i++;
                    }
                }

                $fechaprom = strtotime(date('d-m-Y', $fecha_venci_noti));
                $fechaprom1 = date('d-m-Y', $fecha_venci_noti);
                $time = time();
                $fechaactual = strtotime(date('d-m-Y', $time));

                if ($ver[14] == 'PROCESO' or $ver[14] == 'REPROCESO' or $ver[14] == 'ACTIVADO FLT' or $ver[14] == 'ACTIVADO GNP' or $ver[14] == 'ACTIVADO MED') {
                    if ($fechaprom > $fechaactual) {
                        echo 'A TIEMPO estado ALGUN PROCESO' . $fechaprom1;
                        $fechas_a_tiempo[]=$fechaprom1;
                    } else if ($fechaprom < $fechaactual) {
                        echo 'VENCIDO estado ALGUN PROCESO' . $fechaprom1;
                        $fechas_vencidas[]=$fechaprom1;
                    } else if ($fechaprom == $fechaactual) {
                        echo 'POR VENCERSE estado ALGUN PROCESO' . $fechaprom1;
                        $fechas_por_vencerse[]=$fechaprom1;
                    }
                }

                $consulta = "select cd_estado from cam_estado where folio='$ver[0]'";
                $resultado = mysqli_query($conn, $consulta);

                while ($verfecha = mysqli_fetch_row($resultado)) {
                    $datosfecha = $verfecha[0];
                    $fechap = strtotime(date("d-m-Y", strtotime($datosfecha)));

                    if ($ver[14] == "TERMINADO CON POLIZA" or $ver[14] == "TERMINADO") {
                        if ($fechaprom > $fechap) {
                            echo 'A TIEMPO estado TERMINADO' . $fechaprom1;
                            $fechas_a_tiempo[]=$fechaprom1;
                        } else if ($fechaprom < $fechap) {
                            echo 'VENCIDO estado TERMINADO' . $fechaprom1;
                            $fechas_vencidas[]=$fechaprom1;
                        } else if ($fechaprom == $fechap) {
                            echo 'POR VENCERSE estado TERMINADO' . $fechaprom1;
                            $fechas_por_vencerse[]=$fechaprom1;
                        }
                    }
                }
            }
        }
    } elseif ($ver[3]=='MOVIMIENTOS'){

    } elseif ($ver[3]=='ALTA DE POLIZA'){

    }else {
        echo "NO SE PUEDE CALCULAR";
        $fechas_no_calculadas[]=$ver[0];
    }
}

// Cerrar la conexión a la base de datos
$conn->close();

echo "<br>";
echo "<br>";

// Imprimir fechas a tiempo
echo "Fechas a Tiempo:<br>";
foreach ($fechas_a_tiempo as $fecha) {
    echo $fecha . "<br>";
}

// Imprimir fechas por vencerse
echo "<br>Fechas por Vencerse:<br>";
foreach ($fechas_por_vencerse as $fecha) {
    echo $fecha . "<br>";
}

// Imprimir fechas vencidas
echo "<br>Fechas Vencidas:<br>";
foreach ($fechas_vencidas as $fecha) {
    echo $fecha . "<br>";
}

// Imprimir fechas no calculadas
echo "<br>Fechas No Calculadas:<br>";
foreach ($fechas_no_calculadas as $fecha) {
    echo $fecha . "<br>";
}

?>