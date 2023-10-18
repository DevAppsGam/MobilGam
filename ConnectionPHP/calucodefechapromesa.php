<?php
if ($ver[3] == 'PAGOS') {
    if ($ver[14] == 'CANCELADO' or $ver[14] == 'ENVIADO') {
        ?>
    <?php
    } else { ?>
            <?php
            $sqlf = "select fechaest from promesa where folio='$ver[0]'";
            $resultf = mysqli_query($conexion, $sqlf);
            while ($verf = mysqli_fetch_row($resultf)) {
                $datosf = $verf[0];
                $fecha = $verf[0];
                $dias = 1;

                //Arreglo de los días feriados en GAM
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

                //Convierte la fecha en formato Unix
                $comienzo = strtotime($fecha);
                //Inicializa la fecha final
                $fecha_venci_noti = $comienzo;

                //Inicializa el contador
                $i = 0;

                while ($i < $dias) {
                    //Se suma un dia a la fecha final (86400 segundos)
                    $fecha_venci_noti += 86400;
                    $es_feriado = FALSE;

                    //Recorro todos los feriados
                    foreach ($feriados as $key => $feriado) {
                        //Verifico si la fecha final actual es feriado o no
                        if (date("Y-m-d", $fecha_venci_noti) === date("Y-m-d", strtotime($feriado))) {
                            //En caso de ser feriado cambio mi variable a TRUE
                            $es_feriado = TRUE;
                        }
                    }

                    //Verifico que no sea un sabado, domingo o feriado
                    if (!(date("w", $fecha_venci_noti) == 6 || date("w", $fecha_venci_noti) == 0 || $es_feriado)) {
                        //En caso de no ser sabado, domingo o feriado aumentamos nuestro contador
                        $i++;
                    }
                }

                $fechaprom = strtotime(date('d-m-Y', $fecha_venci_noti));
                $fechaprom1 = date('d-m-Y', $fecha_venci_noti);
                $time = time();
                $fechaactual = strtotime(date('d-m-Y', $time));

                //Validamos fecha promesa y fecha actual para accionar el semaforo
                if ($ver[14] == 'PROCESO' or $ver[14] == 'REPROCESO' or $ver[14] == 'ACTIVADO FLT' or $ver[14] == 'ACTIVADO GNP' or $ver[14] == 'ACTIVADO MED') {

                    if ($fechaprom > $fechaactual) { ?>
                        <img src="img/ver.png" class="semaforoV" />
                        &nbsp;
                    <?php
                        echo $fechaprom1;
                    } else if ($fechaprom < $fechaactual) { ?>
                        <img src="img/roj.png" class="semaforoR" />
                        &nbsp;
                    <?php
                        echo $fechaprom1;
                    } else if ($fechaprom = $fechaactual) { ?>
                        <img src="img/ama.png" class="semaforoA" />
                        &nbsp;
            <?php
                        echo $fechaprom1;
                    }
                }
            } //cierra while
            ?>
        </small>

    <?php
    } //cierre else
    ?>

    <!-- Agrego para que el semaforo no cambie si esta en estas condiciones -->
    <small>
        <?php
        $consulta = "select cd_estado from cam_estado where folio='$ver[0]'";
        $resultado = mysqli_query($conexion, $consulta);

        while ($verfecha = mysqli_fetch_row($resultado)) {
            $datosfecha = $verfecha[0]; //cambio de estado
            $fechap = strtotime(date("d-m-Y", strtotime($datosfecha))); //formateo de la fecha cambio de estado

            if ($ver[14] == "TERMINADO CON POLIZA" or $ver[14] == "TERMINADO") { //condiciones

                if ($fechaprom > $fechap) { ?>
                    <img src="img/ver.png" class="semaforoV" />
                    &nbsp;
                <?php
                    echo $fechaprom1;
                } else if ($fechaprom < $fechap) { ?>
                    <img src="img/roj.png" class="semaforoR" />
                    &nbsp;
                <?php
                    echo $fechaprom1;
                } else if ($fechaprom = $fechap) { ?>
                    <img src="img/ama.png" class="semaforoA" />
                    &nbsp;
        <?php
                    echo $fechaprom1;
                }
            }
        }
        ?>
    </small>

    <?php

} //cierre pagos

if ($ver[3] == 'ALTA DE POLIZA') {
    $sqlr = "select * from rango where tiporan='$ver[5]'";
    $resr = mysqli_query($conexion, $sqlr);
    if ($ver[14] == 'CANCELADO' or $ver[14] == 'ENVIADO') { ?>
        <small>***</small>
        <?php
    } else {
        while ($verr = mysqli_fetch_row($resr)) {
            $d_promesar = $verr[2];
        ?>
            <b><small>
                    <?php
                    $sqlf = "select fechaest from promesa where folio='$ver[0]'";
                    $resultf = mysqli_query($conexion, $sqlf);
                    while ($verf = mysqli_fetch_row($resultf)) {
                        $datosf = $verf[0];
                        $fecha = $verf[0];
                        $dias = $verr[2];

                        //Arreglo de días feriados en GAM
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

                        //Convierte la fecha en formato Unix
                        $comienzo = strtotime($fecha);
                        //Inicializa la fecha final
                        $fecha_venci_noti = $comienzo;

                        //Inicializa el contador
                        $i = 0;

                        while ($i < $dias) {
                            //Se suma un día a la fecha final (86400 segundos)
                            $fecha_venci_noti += 86400;
                            $es_feriado = FALSE;

                            //Recorro todos los dias feriados
                            foreach ($feriados as $key => $feriado) {
                                //Verifico si la fecha final actual es feriado o no
                                if (date("Y-m-d", $fecha_venci_noti) === date("Y-m-d", strtotime($feriado))) {
                                    //En caso de ser feriado cambio mi variabla a TRUE
                                    $es_feriado = TRUE;
                                }
                            }

                            //Verifico que no sea un sabado, domingo o feriado
                            if (!(date("w", $fecha_venci_noti) == 6 || date("w", $fecha_venci_noti) == 0 || $es_feriado)) {
                                //En caso de ser feriado cambio mi variable a true
                                $i++;
                            }
                        }

                        $fechaprom = strtotime(date('d-m-Y', $fecha_venci_noti));
                        $fechaprom1 = date('d-m-Y', $fecha_venci_noti);
                        $time = time();
                        $fechaactual = strtotime(date('d-m-Y', $time));

                        //Validamos fecha promesa y fecha actual para accionar el semaforo
                        if ($ver[14] == 'PROCESO' or $ver[14] == 'REPROCESO' or $ver[14] == 'ACTIVADO MED' or $ver[14] == 'ACTIVADO GNP' or $ver[14] == 'ACTIVADO FLT') {

                            if ($fechaprom > $fechaactual) { ?>
                                <img src="img/ver.png" class="semaforoV" />
                                &nbsp;
                            <?php
                                echo $fechaprom1;
                            } else if ($fechaprom < $fechaactual) { ?>
                                <img src="img/roj.png" class="semaforoR" />
                                &nbsp;
                            <?php
                                echo $fechaprom1;
                            } else if ($fechaprom = $fechaactual) { ?>
                                <img src="img/ama.png" class="semaforoA" />
                                &nbsp;
                    <?php
                                echo $fechaprom1;
                            }
                        }
                    }
                    ?>
                </small></b>
    <?php
        } //cierre while
    } //cierre else
    ?>

    <!-- Agrego para que el semaforo no cambie si esta en estas condiciones -->
    <small>
        <?php
        $consulta = "select cd_estado from cam_estado where folio='$ver[0]'";
        $resultado = mysqli_query($conexion, $consulta);

        while ($verfecha = mysqli_fetch_row($resultado)) {
            $datosfecha = $verfecha[0]; //cambio de estado
            $fechap = strtotime(date("d-m-Y", strtotime($datosfecha))); //formateo de la fecha cambio de estado

            if ($ver[14] == "TERMINADO CON POLIZA" or $ver[14] == "TERMINADO") { //condiciones

                if ($fechaprom > $fechap) { ?>
                    <img src="img/ver.png" class="semaforoV" />
                    &nbsp;
                <?php
                    echo $fechaprom1;
                } else if ($fechaprom < $fechap) { ?>
                    <img src="img/roj.png" class="semaforoR" />
                    &nbsp;
                <?php
                    echo $fechaprom1;
                } else if ($fechaprom = $fechap) { ?>
                    <img src="img/ama.png" class="semaforoA" />
                    &nbsp;
        <?php
                    echo $fechaprom1;
                }
            }
        }
        ?>
    </small>


    <?php
} //cierre alta poliza


if ($ver[3] == 'MOVIMIENTOS') {
    $sqlr = "select * from producto where producto='$ver[9]'";
    $resr = mysqli_query($conexion, $sqlr);

    if ($ver[14] == 'CANCELADO' or $ver[14] == 'ENVIADO') { ?>
        <small>***</small>
        <?php

        //CIERRE DE LA CONDICION CANCELADO Y ENVIADO

    } else { //ELSE 1

        while ($verr = mysqli_fetch_row($resr)) { //WHILE 1

        ?>
            <b>
                <small>
                    <?php
                    $sqlf = "select fechaest from promesa where folio='$ver[0]'"; //FECHA DEL CAMBIO DE ESTADO PARA PROCESO Y REPROCESO
                    $resultf = mysqli_query($conexion, $sqlf);
                    while ($verf = mysqli_fetch_row($resultf)) { //WHILE 2
                        $fecha = $verf[0]; //fecha del cambio de estado proceso y reproceso
                        $dias = $verr[3]; //dias de promesa para resolver tramite

                        //Arreglo de los dias feriados en GAM
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
                        //Convierte la fecha en formato Unix
                        $comienzo = strtotime($fecha);
                        //Inicializa la fecha final
                        $fecha_venci_noti = $comienzo;

                        //Inicializo el contador
                        $i = 0;

                        while ($i < $dias) {
                            //Se suma un dia a la fecha final (86400 segundos)
                            $fecha_venci_noti += 86400;
                            $es_feriado = FALSE;

                            //Recorro todos los feriados
                            foreach ($feriados as $key => $feriado) {
                                //Verifico si la fecha final actual es feriado o no
                                if (date("Y-m-d", $fecha_venci_noti) === date("Y-m-d", strtotime($feriado))) {
                                    //En caso de ser feriado cambio mi variable a TRUE
                                    $es_feriado = TRUE;
                                }
                            }
                            //Verifico que no sea un sabado, domingo o feriado
                            if (!(date("w", $fecha_venci_noti) == 6 || date("w", $fecha_venci_noti) == 0 || $es_feriado)) {
                                $i++;
                            }
                        }

                        $fechaprom = strtotime(date('d-m-Y', $fecha_venci_noti));
                        $fechaprom1 = date('d-m-Y', $fecha_venci_noti);
                        $time = time();
                        $fechaactual = strtotime(date('d-m-Y', $time));

                        //Validamos fecha promesa y fecha actual para accionar el semaforo
                        if ($ver[14] == 'PROCESO' or $ver[14] == 'REPROCESO' or $ver[14] == 'ACTIVADO MED' or $ver[14] == 'ACTIVADO GNP' or $ver[14] == 'ACTIVADO FLT') {

                            if ($fechaprom > $fechaactual) { ?>
                                <img src="img/ver.png" class="semaforoV" />
                                &nbsp;
                            <?php
                                echo $fechaprom1;
                            } else if ($fechaprom < $fechaactual) { ?>
                                <img src="img/roj.png" class="semaforoR" />
                                &nbsp;
                            <?php
                                echo $fechaprom1;
                            } else if ($fechaprom = $fechaactual) { ?>
                                <img src="img/ama.png" class="semaforoA" />
                                &nbsp;
                    <?php
                                echo $fechaprom1;
                            }
                        }
                    }
                    ?>
                </small></b>
    <?php

        } //cierre while
    } //cierre else

    ?>

    <!-- Agrego para que el semaforo no cambie si esta en estas condiciones -->
    <small>
        <?php
        $consulta = "select cd_estado from cam_estado where folio='$ver[0]'";
        $resultado = mysqli_query($conexion, $consulta);
        while ($verfecha = mysqli_fetch_row($resultado)) {
            $datosfecha = $verfecha[0]; //cambio de estado
            $fechap = strtotime(date("d-m-Y", strtotime($datosfecha))); //reseteo de la fecha de cambio de estado

            if ($ver[14] == "TERMINADO") { //condiciones

                if ($fechaprom > $fechap) { ?>
                    <img src="img/ver.png" class="semaforoV" />
                    &nbsp;
                <?php
                    echo $fechaprom1;
                } else if ($fechaprom < $fechap) { ?>
                    <img src="img/roj.png" class="semaforoR" />
                    &nbsp;
                <?php
                    echo $fechaprom1;
                } else if ($fechaprom = $fechap) { ?>
                    <img src="img/ama.png" class="semaforoA" />
                    &nbsp;
        <?php
                    echo $fechaprom1;
                }
            }
        }
        ?>
    </small>

<?php

} //cierre movimientos
?>
</b>
</td>