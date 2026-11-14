# PeliQlas

Aplicación móvil nativa para iOS desarrollada en Swift y SwiftUI que permite descubrir películas populares, consultar información detallada (sinopsis, director y elenco), realizar búsquedas por título y gestionar una lista personal de películas favoritas de forma local.

---

## Descripción

Ante la saturación de catálogos en plataformas audiovisuales y la dispersión de información sobre estrenos o fichas técnicas, **PeliQlas** ofrece una interfaz limpia, rápida e intuitiva para explorar cine desde dispositivos iPhone. El propósito de la aplicación es brindar una experiencia fluida para consultar películas en tendencia, buscar títulos específicos en español (`es-MX`) y guardar recomendaciones personales para consultarlas posteriormente sin depender de cuentas externas.

---

## Funcionalidades

* **Exploración de películas populares:** Visualización del catálogo de películas en tendencia obtenido en tiempo real desde The Movie Database (TMDB), con manejo de estados de carga, vacíos y reintento ante errores de red.
* **Búsqueda por título:** Buscador integrado (`SearchView`) para localizar películas por nombre mediante consultas dinámicas a la API.
* **Detalle completo de película:** Pantalla de ficha técnica (`MovieDetailView`) con póster remoto, sinopsis, fecha de estreno, calificación, director y reparto principal.
* **Gestión de favoritos con persistencia local:** Posibilidad de agregar o quitar películas de la lista de favoritos (`FavoritesView`), conservando los datos en el dispositivo mediante SwiftData.
* **Perfil de usuario:** Visualización y edición básica de información del perfil dentro de la aplicación (`ProfileView` y `EditProfileView`).
* **Navegación por pestañas:** Estructura principal organizada mediante `MainTabView` para alternar entre exploración, búsqueda, favoritos y perfil.

---

## Tecnologías

* **Lenguaje:** Swift 5.9+
* **Interfaz de usuario:** SwiftUI
* **Persistencia local:** SwiftData (`ModelContext`)
* **Networking:** `URLSession` con concurrencia moderna (`async/await`) y `JSONDecoder`
* **Registro y diagnóstico:** `OSLog` (`Logger`)
* **Pruebas unitarias:** XCTest (`PeliQlasTests`)
* **API externa:** The Movie Database (TMDB) API v3
* **Control de versiones:** Git y GitHub

---

## Requisitos

* **Sistema operativo de desarrollo:** macOS Sonoma 14.0 o superior
* **IDE:** Xcode 15.1 o superior
* **Versión mínima de despliegue (Deployment Target):** iOS 17.2 o superior
* **Conexión a internet:** Requerida para consultar el catálogo, realizar búsquedas y descargar pósteres desde TMDB
* **Cuenta en TMDB:** Necesaria para obtener un *API Read Access Token (Bearer Token)* gratuito

---

## Instalación y configuración

1. **Clonar el repositorio:**
   ```bash
   git clone [https://github.com/jsamuelbt1/peliQlas.git](https://github.com/jsamuelbt1/peliQlas.git)
   cd peliQlas
Configurar las credenciales de la API (ver sección siguiente):
El archivo PeliQlas/PeliQlas/APIConfig.swift está excluido del repositorio mediante .gitignore por seguridad. Deberás crearlo manualmente antes de compilar.

Abrir el proyecto en Xcode:
Abre el archivo del proyecto ubicado en: PeliQlas/PeliQlas.xcodeproj

Configuración de servicios externos
La aplicación consume la API v3 de The Movie Database (TMDB) autenticando cada petición mediante un token tipo Bearer en el encabezado Authorization.

Para configurar el acceso sin exponer credenciales en el repositorio:

Crea una cuenta gratuita en themoviedb.org y genera un Token de acceso de lectura a la API (v4 auth / Bearer Token) desde Configuración > API.

Dentro de la carpeta PeliQlas/PeliQlas/, crea un archivo llamado APIConfig.swift (asegúrate de marcar el Target PeliQlas al crearlo en Xcode).

Agrega la siguiente estructura sustituyendo <TU_TOKEN_DE_ACCESO_TMDB> por tu token real:
import Foundation
enum APIConfig {
    static let baseURL = "[https://api.themoviedb.org/3](https://api.themoviedb.org/3)"
    static let accessToken = "<TU_TOKEN_DE_ACCESO_TMDB>"
}

Ejecución
1. Una vez creado APIConfig.swift y abierto PeliQlas/PeliQlas.xcodeproj en Xcode, espera a que finalice la indexación del proyecto.
2. En la barra superior de Xcode, selecciona el esquema PeliQlas y elige un simulador con iOS 17.2 o superior (por ejemplo, iPhone 15 o iPhone 16).
3. Compila y ejecuta la aplicación presionando Cmd + R (o el botón Run).
4. (Opcional) Para ejecutar las pruebas unitarias disponibles en PeliQlasTests, presiona Cmd + U.

**Documentación técnica**
Arquitectura
El proyecto sigue el patrón arquitectónico MVVM (Model-View-ViewModel) con separación explícita de responsabilidades y desacoplamiento de la capa de red mediante protocolos:
PeliQlas/
├── PeliQlas/
│   ├── Models/
│   │   ├── MovieDTO.swift          # Modelos de transferencia de datos (Decodable) para respuestas JSON de TMDB
│   │   ├── Movie.swift             # Modelo de dominio utilizado por las vistas y ViewModels
│   │   ├── MovieMapper.swift       # Transformación de DTOs de red a modelos de dominio
│   │   └── FavoriteMovie.swift     # Entidad persistente (@Model) almacenada en SwiftData
│   ├── ViewModels/
│   │   ├── MovieListViewModel.swift    # Lógica y estado de la lista de películas populares
│   │   ├── SearchViewModel.swift       # Lógica y estado de búsqueda de películas
│   │   └── MovieDetailViewModel.swift  # Lógica de carga de detalle, dirección y reparto
│   ├── Views/
│   │   ├── MainTabView.swift       # Contenedor principal de navegación por pestañas
│   │   ├── MovieListView.swift     # Pantalla principal de catálogo popular
│   │   ├── MovieRowView.swift      # Componente reutilizable de fila/tarjeta de película
│   │   ├── PosterView.swift        # Carga y renderizado de imágenes remotas de pósteres
│   │   ├── MovieDetailView.swift   # Vista de detalle de película, sinopsis y créditos
│   │   ├── SearchView.swift        # Interfaz de búsqueda por título
│   │   ├── FavoritesView.swift     # Lista de películas guardadas localmente
│   │   ├── ProfileView.swift       # Vista de perfil de usuario
│   │   └── EditProfileView.swift   # Formulario de edición de perfil
│   ├── MovieService.swift          # Capa de red (URLSession) y protocolo MovieServiceProtocol
│   ├── APIError.swift              # Tipado y manejo centralizado de errores HTTP y de red
│   ├── FavoritesManager.swift      # Operaciones CRUD sobre favoritos en SwiftData
│   ├── APIConfig.swift             # (Local, ignorado en Git) Base URL y Bearer Token de TMDB
│   └── PeliQlasApp.swift           # Punto de entrada de la aplicación y configuración del contenedor SwiftData
├── PeliQlasTests/                  # Pruebas unitarias (búsqueda de películas y MovieListViewModel)
└── PeliQlasUITests/                # Estructura base para pruebas de interfaz

**Networking**
La comunicación externa se centraliza en MovieService (que implementa MovieServiceProtocol), utilizando URLSession con async/await y decodificación automática mediante JSONDecoder con estrategia .convertFromSnakeCase. Todas las peticiones incluyen el parámetro language=es-MX y un tiempo de espera (timeoutInterval) de 15 segundos.
1. API utilizada: The Movie Database (TMDB) REST API v3 (https://api.themoviedb.org/3).
2. Endpoints principales:
   - GET /movie/popular: Obtiene el listado de películas populares actuales.
   - GET /search/movie?query={texto}: Busca películas cuyo título coincida con el parámetro query.
   - GET /movie/{id}?append_to_response=credits: Obtiene el detalle completo de una película junto con su elenco (cast) y equipo técnico (crew, filtrado para extraer al director) en una sola petición HTTP.
3. Modelos de respuesta relevantes:
   - MovieListResponseDTO: Envoltorio paginado de TMDB que contiene el arreglo results: [MovieDTO].
   - MovieDTO: Representa los datos básicos de cada película (id, title, overview, posterPath, releaseDate, voteAverage).
   - MovieDetailDTO: Extiende los datos de la película incluyendo créditos (credits) para mapear reparto y dirección hacia el modelo de dominio Movie a través de MovieMapper.
4. Manejo de errores: APIError traduce fallos de conectividad (URLError) y códigos de estado HTTP fuera del rango 200...299 en casos controlados (noConnection, timeout, httpError, decodingError, etc.).

**Persistencia**
- Información almacenada localmente: Películas marcadas como favoritas por el usuario (identificador de película movieID y metadatos asociados para su visualización offline en la pestaña de favoritos).
- Mecanismo utilizado: SwiftData (@Model en FavoriteMovie y operaciones gestionadas mediante ModelContext en FavoritesManager).
- Registro de errores: FavoritesManager implementa OSLog (Logger) para registrar fallos al ejecutar context.save(), evitando silenciar excepciones durante la escritura en disco.

Integrantes
- Alyn Rivera Abreu
- José Samuel Badillo Toledo
