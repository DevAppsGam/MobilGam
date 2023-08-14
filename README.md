# Proyecto de Aplicación de Contactos de Asesores de Vida

Este proyecto es una aplicación móvil desarrollada en Flutter para asesores y profesionales en el campo de seguros de vida. La aplicación permite acceder y gestionar información de contactos de manera eficiente.

## Funcionalidades Principales

1. **Inicio de Sesión (LoginPage)**:
   - Los usuarios pueden iniciar sesión con sus credenciales.
   - Se verifica la autenticación y se redirige a la pantalla de Asesores si el inicio de sesión es exitoso.

2. **Pantalla de Asesores (AsesoresPage)**:
   - Menú lateral con opciones como "INICIO", "CONTACTOS" y "Cerrar sesión".
   - Los usuarios pueden navegar a diferentes secciones de la aplicación.
   - Al seleccionar "CONTACTOS", se muestra la pantalla de Contactos de Vida.

3. **Pantalla de Contactos de Vida (contactoVidaPage)**:
   - Cuadrícula de contactos de asesores de vida con ícono, nombre y rol.
   - Los usuarios pueden seleccionar un contacto para ver los detalles en la pantalla de Detalles del Contacto.

4. **Pantalla de Detalles del Contacto de Vida (contactoDetalle)**:
   - Muestra detalles como nombre, rol, número de teléfono y correo electrónico.
   - Tocar el número de teléfono abre la aplicación de teléfono para realizar una llamada.
   - Tocar el correo electrónico abre la aplicación de correo para componer un correo.

## Tecnologías y Paquetes Utilizados

- Flutter: Framework de desarrollo de aplicaciones móviles multiplataforma.
- `url_launcher`: Paquete para abrir enlaces externos en aplicaciones nativas.
- PHP y MySQL: Utilizados para obtener detalles de los contactos desde la base de datos.



## Licencia

Este proyecto está bajo la Licencia MIT. Consulta el archivo [LICENSE](/LICENSE) para más detalles.

