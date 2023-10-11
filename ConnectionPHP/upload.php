<?php
// Verifica si se recibió el archivo y otros datos del formulario
if (isset($_FILES['file']) && isset($_POST['id'])) {
    // Ruta donde se almacenarán los archivos cargados (asegúrate de que esta ruta sea accesible y tenga permisos de escritura)
    $uploadDirectory = 'http://localhost/docsDesarrolla,';

    // Nombre del archivo original
    $originalFileName = $_FILES['file']['name'];

    // Nombre temporal del archivo
    $tempFileName = $_FILES['file']['tmp_name'];

    // ID de la póliza relacionada (recibido desde la aplicación)
    $polizaId = $_POST['id'];

    // Genera un nuevo nombre de archivo basado en la ID de la póliza
    $newFileName = $polizaId . '_' . $originalFileName;

    // Ruta completa del archivo en el servidor
    $uploadPath = $uploadDirectory . $newFileName;

    // Mueve el archivo temporal al directorio de carga
    if (move_uploaded_file($tempFileName, $uploadPath)) {
        // El archivo se cargó correctamente
        echo 'El archivo se ha cargado con éxito.';
    } else {
        // Hubo un error al cargar el archivo
        echo 'Error al cargar el archivo.';
    }
} else {
    // No se recibieron datos o el archivo
    echo 'No se recibieron datos o archivo.';
}
?>
