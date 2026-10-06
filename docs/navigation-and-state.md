#  Navegación y Estado (PelíQlas)

Este documento detalla la estructura de navegación, la organización de la información por pantalla y la gestión del estado 
para MVP de la aplicación de películas conectada a la API de TMDB.

---

## 1. Mapa de Navegación y Estrategia
### Vista general del diseño visual (Figma)

<img width="828" height="461" alt="Screenshot 2026-10-03 at 19 31 01" src="https://github.com/user-attachments/assets/538dab46-c509-4b65-b4d1-3daaa899b450" />

### Estructura de Flujos
### Estructura de Flujos
* **Punto de Partida (Raíz):** La aplicación inicia en la vista de **Bienvenida** (`WelcomeView`), donde el usuario visualiza el logotipo, un saludo y un selector de perfiles activos (ej. Álex o Lucía), además de una tarjeta destacada con sugerencias].
* **Transición Principal:** Al presionar el botón *"Entrar como [Usuario]"*, la app realiza una transición de pantalla completa (`fullScreenCover`) para llevar al usuario al menú principal de exploración.
* **Pantalla de Exploración (`HomeView`):** Muestra la barra de búsqueda y secciones dinámicas como "Populares" con tarjetas de películas que incluyen póster, título, calificación y botones de acción. Desde aquí se abren dos rutas:
  1. **Hacia el Detalle:** Al hacer *tap* sobre cualquier tarjeta de película, se navega hacia adelante mediante un `NavigationStack` para abrir la **Vista de Detalle** (`MovieDetailView`).
  2. **Hacia Accesos Directos:** Botones para gestión de perfiles o búsqueda rápida.

### Mecanismos de SwiftUI Utilizados
* **`NavigationStack`:** Utilizado en el menú principal para la navegación jerárquica tradicional (de la lista de películas al detalle), permitiendo apilar y desapilar vistas de forma fluida mediante `navigationDestination(for:)`.
* **`fullScreenCover` / Presentación Modal:** Utilizado tanto para la transición inicial del perfil hacia el inicio como para la **Vista de Detalle** (la cual incluye un botón de cierre `X` en la esquina superior derecha tal como se ve en el diseño)[cite: 1], permitiendo superponer la información y cerrarla fácilmente regresando a la posición anterior.

---

## 2. Información por Pantalla

### Pantalla 1: Bienvenida / Selección de Perfil (`WelcomeView`)
* **Qué muestra:** El logotipo de la aplicación (`peliQlas`), el selector de perfiles de usuario (Álex, Lucía) con avatares, y una tarjeta destacada con una recomendación personalizada para la noche de cine (póster, título, año, género y calificación)[cite: 1].
* **Qué recibe (`let`):** Los datos estáticos de los perfiles disponibles precargados en el modelo de usuario.
* **Qué modifica (Estado local / `@State`):** El perfil actualmente seleccionado (para alternar el check de selección, ej. cambiar de Álex a Lucía) y el texto dinámico del botón de acceso[cite: 1].
* **Qué necesita conservar:** El ID o nombre del perfil activo para pasarlo como contexto global a las siguientes vistas de la aplicación.

### Pantalla 2: Pantalla de Inicio / Exploración (`HomeView`)
* **Qué muestra:** Una barra de búsqueda superior (`TextField`), un icono de acceso al perfil del usuario, y la sección "Populares" que despliega tarjetas de películas con póster, título, año de estreno, géneros, botón de favoritos y botón de reproducción[cite: 1].
* **Qué recibe (`let`):** El perfil de usuario seleccionado en la pantalla anterior y la instancia del servicio de red de TMDB.
* **Qué modifica (Estado local / `@State`):** El texto introducido en la barra de búsqueda (`searchQuery`) y el estado visual de los botones de favoritos (icono de corazón) de manera individual en cada tarjeta[cite: 1].
* **Qué necesita conservar:** La lista general de películas obtenidas de la API y el estado de sincronización de favoritos para reflejarlos correctamente en la interfaz.

### Pantalla 3: Detalle de Película (`MovieDetailView`)
* **Qué muestra:** Un póster grande de la película (ej. *Dune*), un botón para marcar como favorito (corazón), un botón de cierre (`X`), el título oficial, géneros, calificación en estrellas (ej. 8.4/10), un bloque con el año de estreno, el director y la sección de actores principales[cite: 1].
* **Qué recibe (`let`):** El identificador o el objeto completo de la película seleccionada desde la pantalla de inicio para mapear todos sus detalles[cite: 1].
* **Qué modifica (Estado local / `@State`):** El estado booleano o visual del botón de favorito (activado/desactivado) al hacer *tap* sobre el icono del corazón[cite: 1].
* **Qué necesita conservar:** La persistencia local de los favoritos para que, al cerrar esta vista, la película se mantenga guardada en la base de datos o almacenamiento local.

---

## 3. Organización del Estado

Para mantener una arquitectura limpia y escalable en SwiftUI, los datos se organizan de la siguiente manera:

* **Estado Local (`@State`):** 
  * Se utiliza en la **Vista de Bienvenida** para gestionar qué avatar está seleccionado en el momento.
  * Se utiliza en las tarjetas de película y en la **Vista de Detalle** para alternar de manera inmediata el estado visual del botón de favorito (`isFavorite: Bool`).
* **Modelos Observables con `@Observable` (ViewModel / Servicios):** 
  * La gestión de las peticiones a la API de TMDB (listas de populares, detalles y búsqueda) vivirá en un objeto observable dedicado (ej. `MovieViewModel`). Esto separa la lógica de red de la interfaz visual.
* **Estado Global / Persistencia Local (`@Environment` / Contenedor de Favoritos):** 
  * La lista de películas favoritas se almacenará mediante un gestor de persistencia local (como *SwiftData* o un gestor local envuelto en un observable). Esto permite que tanto la pantalla de inicio como la de detalle consulten y modifiquen la misma "fuente de verdad" en tiempo real sin perder los datos al cerrar la app.
 

---
<img width="678" height="385" alt="Screenshot 2026-10-03 at 20 15 36" src="https://github.com/user-attachments/assets/0ba7c5d2-aa34-4fb6-b1aa-bf4e5d8ea065" />

## 4. Flujo y Pantalla de Búsqueda 

### Vista de Resultados de Búsqueda (`SearchView`)
* **Qué muestra:** Una barra de búsqueda superior activa con el texto ingresado por el usuario (ej. *"una película de huevos"*), el encabezado de sección *"Resultados"*, y una lista vertical de tarjetas que muestran el póster, el título oficial, el año de estreno, los géneros y el botón de favoritos de cada coincidencia encontrada[cite: 2].
* **Qué recibe:** El parámetro de consulta ingresado por el usuario y el servicio de red de TMDB para realizar el filtrado dinámico.
* **Qué modifica (Estado local / `@State`):** El texto de búsqueda en tiempo real (`searchQuery`), la lista de películas filtradas devueltas por la API y el estado visual individual de los botones de favorito en cada celda[cite: 2].
* **Qué necesita conservar:** El historial temporal de la consulta y la sincronización con la base de datos local de favoritos.

### Estrategia de Navegación para la Búsqueda
* **Transición desde el Inicio:** Al hacer *tap* sobre la barra de búsqueda en la **Pantalla de Inicio**, la aplicación despliega la vista de búsqueda (ya sea mediante una transición modal o un contenedor de navegación integrado).
* **Navegación al Detalle:** Al igual que en el flujo principal, cada tarjeta de resultado en la **Vista de Búsqueda** funciona como un elemento interactivo envuelto en el `NavigationStack`, permitiendo al usuario navegar directamente hacia la **Vista de Detalle** (`MovieDetailView`) de la película seleccionada.


<img width="276" height="478" alt="Screenshot 2026-10-03 at 20 31 37" src="https://github.com/user-attachments/assets/5e727f7c-faa0-459d-ba91-7f041b0b99ff" />


### Vista de Búsqueda Sin Resultados (`NoResultsView`)
* **Qué muestra:** El encabezado de la sección de resultados acompañado de un mensaje claro de estado vacío que indica *"No se encontraron resultados para:"* seguido de la consulta exacta ingresada por el usuario (ej. *"blablablablal xdxdxdP"*)[cite: 3].
* **Qué receives (`let`):** El texto de la consulta fallida ingresada en la barra de búsqueda superior.
* **Qué modifica (Estado local / `@State`):** El texto dinámico que refleja la búsqueda no encontrada y la visibilidad del componente de estado vacío frente a la lista de resultados regulares[cite: 3].
* **Qué necesita conservar:** El estado activo de la barra de búsqueda para permitir al usuario corregir el texto o realizar una nueva consulta sin perder el flujo de navegación.





























