# Proyecto de Aplicación IntraGAM

Este proyecto es una aplicación móvil desarrollada en Flutter para asesores y profesionales en el campo de seguros de vida. La aplicación permite acceder y gestionar información de contactos de manera eficiente, además de visualizar estadísticas relevantes mediante gráficas.

## Funcionalidades Principales

1. **Inicio de Sesión**:
   - Los usuarios pueden iniciar sesión con sus credenciales.
   - Se verifica la autenticación y se redirige a la pantalla principal si el inicio de sesión es exitoso.

2. **Pantalla Principal**:
   - Menú lateral con opciones como "INICIO", "CONTACTOS" y "Cerrar sesión".
   - Los usuarios pueden navegar a diferentes secciones de la aplicación.
   - Al seleccionar "CONTACTOS", se muestra la pantalla de contactos de vida.

3. **Pantalla de Contactos de Vida**:
   - Cuadrícula de contactos de asesores de vida con ícono, nombre y rol.
   - Los usuarios pueden seleccionar un contacto para ver los detalles en la pantalla de Detalles del Contacto.

4. **Pantalla de Detalles del Contacto de Vida**:
   - Muestra detalles como nombre, rol, número de teléfono y correo electrónico.
   - Tocar el número de teléfono abre la aplicación de teléfono para realizar una llamada.
   - Tocar el correo electrónico abre la aplicación de correo para componer un correo.

5. **Pantallas de Gráficas**:
   - Incluye visualizaciones gráficas de estadísticas relevantes sobre las pólizas de vida.
   - Se muestran gráficas de pastel, de línea y de barras para representar los datos de manera visual.

## Tecnologías y Paquetes Utilizados

- Flutter: Framework de desarrollo de aplicaciones móviles multiplataforma.
- `url_launcher`: Paquete para abrir enlaces externos en aplicaciones nativas.
- `fl_chart`: Paquete para la creación de gráficas personalizadas.
- PHP y MySQL: Utilizados para obtener detalles de los contactos desde la base de datos.

## Licencia

Este proyecto está bajo la Licencia de GAM en colaboración con GNP. Consulta el archivo [LICENSE](/LICENSE) para más detalles.
