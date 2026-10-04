#  Navegación y Estado (PelíQlas)

Este documento detalla la estructura de navegación, la organización de la información por pantalla y la gestión del estado 
para MVP de la aplicación de películas conectada a la API de TMDB.

---

## 1. Mapa de Navegación y Estrategia

<img width="467" height="794" alt="Screenshot 2026-10-03 at 19 46 28" src="https://github.com/user-attachments/assets/b9070c97-c7f8-4a2b-b8ee-a3b0143bb550" />

### Estructura de Flujos
* **Punto de Partida (Raíz):** La aplicación inicia en la vista de **Bienvenida** (`WelcomeView`), donde el usuario visualiza el logotipo,
* un saludo y un selector de perfiles activos (ej. Álex o Lucía) además de una tarjeta destacada con sugerencias.
* **Transición Principal:** Al presionar el botón *"Entrar como [Usuario]"*, la app realiza una transición de pantalla completa (`fullScreenCover`)
* para llevar al usuario al menú principal de exploración.
* **Pantalla de Exploración (`HomeView`):** Muestra la barra de búsqueda y secciones dinámicas como
* "Populares" con tarjetas de películas que incluyen póster, título, calificación y botones de acción. Desde aquí se abren dos rutas:
  1. **Hacia el Detalle:** Al hacer *tap* sobre cualquier tarjeta de película
  2. **Hacia Accesos Directos:** Botones para gestión de perfiles o búsqueda rápida
