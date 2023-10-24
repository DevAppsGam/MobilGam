<?php
// Conexión a la base de datos
$servername = "localhost"; // Cambiar si es necesario
$username = "root"; // Cambiar por el nombre de usuario de tu base de datos
$password = ""; // Cambiar por la contraseña de tu base de datos
$dbname = "gamse627_ventanasis";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
}

// Obtener la observación y el id enviados desde Flutter
$id = isset($_GET['id']) ? $_GET['id'] : '';
$archivo = isset($_GET['archivo']) ? $_GET['archivo'] : '';
if (!empty($archivo)) {
    $archivo = strtolower($archivo);
}
echo "el folio es: $id \n";
echo "el nombre del archivo es: $archivo \n";

// Obtener la fecha actual
$fechaActual = date("Y-m-d H:i:s"); // Formato: Año-Mes-Día
echo "la fecha actual es: $fechaActual \n";

// Consultar el id en la tabla folios
$sqlusuario = "SELECT id_agente FROM folios WHERE id='$id'";
$resultado = $conn->query($sqlusuario);
if ($resultado->num_rows > 0) {
    $fila = $resultado->fetch_assoc();
    $id_agente = $fila['id_agente'];
} else {
    $id_agente = '***'; // Si no se encuentra un estado, puedes asignar un valor predeterminado aquí.
}
echo "el id del agente es: $id_agente \n";

// Consultar el nomusuario en la tabla datos_agente
$sqlusername = "SELECT nomusuario FROM datos_agente WHERE id='$id_agente'";
$resultado = $conn->query($sqlusername);

if ($resultado->num_rows > 0) {
    $fila = $resultado->fetch_assoc();
    $user = $fila['nomusuario'];
} else {
    $user = '***'; // Si no se encuentra un estado, puedes asignar un valor predeterminado aquí.
}
echo "el usuario del agente es: $user \n";

function obtenerVersion($conn, $baseNombre, $id, $extension, $idParte)
{
    $version = 1;
    $nombre = $baseNombre . 'v' . $version . '_' . $idParte . '.' . $extension; // Asegurar que la extensión esté incluida

    while (true) {
        $stmt = $conn->prepare("SELECT nombre FROM archivos WHERE nombre = ? AND fk_folio = ?");
        $stmt->bind_param("ss", $nombre, $id);
        $stmt->execute();
        $result = $stmt->get_result();

        // Imprimir información para validar el bucle
        echo "Nombre de archivo a buscar: $nombre\n";
        echo "Número de filas devueltas: " . $result->num_rows . "\n";
        echo "Versión actual: $version\n";

        if ($result->num_rows > 0) {
            $version++;
            $nombre = $baseNombre . 'v' . $version . '_' . $idParte . '.' . $extension; // Asegurar que la extensión esté incluida
        } else {
            break;
        }
    }

    return $version;
}

function archivoExisteParaFolio($conn, $archivo, $id)
{
    $ruta = '../archivos/';
    $nombreArchivo = str_replace($ruta, '', $archivo);
    $nombreArchivo = strtolower($nombreArchivo);
    $extension = pathinfo($nombreArchivo, PATHINFO_EXTENSION);

    $patrones = array(
        'solicitud' => '/(solicitud)(\d+)\.(\w+)/',
        'identificacion' => '/(identificacion)(\d+)\.(\w+)/',
        'comprobante_domicilio' => '/(comprobante_domicilio)(\d+)\.(\w+)/',
        'cartas_extraprima' => '/(cartas_extraprima)(\d+)\.(\w+)/',
        'cartas_rechazo' => '/(cartas_rechazo)(\d+)\.(\w+)/',
        'cartas_adicionales' => '/(cartas_adicionales)(\d+)\.(\w+)/',
        'cuestionario_adicional_suscripcion' => '/(cuestionario_adicional_suscripcion)(\d+)\.(\w+)/',
        'formato_cobranza_electronica' => '/(formato_cobranza_electronica)(\d+)\.(\w+)/',
        'hoja_h107' => '/(hoja_h107)(\d+)\.(\w+)/',
        'solicitudes_adicionales' => '/(solicitudes_adicionales)(\d+)\.(\w+)/',
    );

    foreach ($patrones as $tipo => $patron) {
        if (preg_match($patron, $nombreArchivo, $coincidencias)) {
            $baseNombre = $coincidencias[1];
            $idParte = $coincidencias[2];
            $extensionArchivo = $coincidencias[3];
            $version = 1;

            while (true) {
                $nombreCompleto = $ruta . $baseNombre . 'v' . $version . '_' . $idParte . '.' . $extensionArchivo;
                $stmt = $conn->prepare("SELECT nombre FROM archivos WHERE nombre = ?");
                $stmt->bind_param("s", $nombreCompleto);
                $stmt->execute();
                $result = $stmt->get_result();

                if ($result->num_rows > 0) {
                    $version++;
                } else {
                    return $nombreCompleto;
                }
            }
        }
    }

    // Si no se encuentra ninguna coincidencia, devolver un valor nulo
    return null;
}

// Verificar la existencia del archivo
$archivo_version = archivoExisteParaFolio($conn, $archivo, $id);
if ($archivo_version !== null) {
    echo "El archivo existe para este folio con el nombre: $archivo_version\n";

    // Insertar los archivos
    $stmt = $conn->prepare("INSERT INTO archivos (nombre, fecha_creacion, fk_folio, nomusuario) VALUES (?, ?, ?, ?)");
    $stmt->bind_param("ssss", $archivo_version, $fechaActual, $id, $user);
    $stmt->execute();

    echo "Archivo insertado con éxito.\n";
} else {
    echo "tu archivo $archivo_version no fue insertado\n";
}

// Cerrar la conexión
$conn->close();
?>