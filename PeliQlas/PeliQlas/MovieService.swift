import Foundation

// Protocolo: define QUÉ puede hacer el servicio, sin decir cómo.
// Permite que los ViewModels dependan del protocolo y, en pruebas,
// usar un servicio falso sin internet.
protocol MovieServiceProtocol {
    func fetchPopularMovies() async throws -> [MovieDTO]
    func searchMovies(query: String) async throws -> [MovieDTO]
    func fetchMovieDetail(id: Int) async throws -> MovieDetailDTO
}

// Servicio real: único lugar que sabe de URLSession, HTTP y JSON.
// Las Views y ViewModels solo llaman a estas funciones.
class MovieService: MovieServiceProtocol {

    // URLSession se recibe por el init: por defecto la compartida,
    // pero en pruebas se puede reemplazar.
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        let decoder = JSONDecoder()
        // Convierte release_date -> releaseDate, poster_path -> posterPath, etc.
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = decoder
    }

    // MARK: - Operaciones públicas

    // Películas populares
    func fetchPopularMovies() async throws -> [MovieDTO] {
        let response: MovieListResponseDTO = try await request(path: "/movie/popular")
        return response.results
    }

    // Búsqueda por título
    func searchMovies(query: String) async throws -> [MovieDTO] {
        let response: MovieListResponseDTO = try await request(
            path: "/search/movie",
            queryItems: [URLQueryItem(name: "query", value: query)]
        )
        return response.results
    }

    // Detalle con reparto y director (append_to_response=credits los trae en la misma llamada)
    func fetchMovieDetail(id: Int) async throws -> MovieDetailDTO {
        try await request(
            path: "/movie/\(id)",
            queryItems: [URLQueryItem(name: "append_to_response", value: "credits")]
        )
    }

    // MARK: - Función genérica de solicitud

    // <T: Decodable>: sirve para CUALQUIER modelo decodificable;
    // el tipo se indica al llamarla. `async throws`: es asíncrona y puede lanzar errores.
    private func request<T: Decodable>(path: String,
                                       queryItems: [URLQueryItem] = []) async throws -> T {

        // 1. Construir la URL con URLComponents (escapa bien los espacios y acentos)
        guard var components = URLComponents(string: APIConfig.baseURL) else {
            throw APIError.invalidURL
        }
        components.path += path
        components.queryItems = queryItems + [URLQueryItem(name: "language", value: "es-MX")]

        guard let url = components.url else {
            throw APIError.invalidURL
        }

        // 2. Construir la solicitud HTTP
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.timeoutInterval = 15
        urlRequest.setValue("Bearer \(APIConfig.accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        // 3. Ejecutar la solicitud. `await` pausa esta función sin bloquear la app
        //    hasta que llega la respuesta.
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch let urlError as URLError {
            // Errores de conectividad: se traducen a nuestros propios errores
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed:
                throw APIError.noConnection
            case .timedOut:
                throw APIError.timeout
            case .cancelled:
                throw APIError.cancelled
            default:
                throw APIError.unknown(urlError)
            }
        } catch {
            throw APIError.unknown(error)
        }

        // 4. Validar la respuesta HTTP: debe ser HTTPURLResponse con código 200-299
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.httpError(statusCode: httpResponse.statusCode)
        }

        // 5. Decodificar el JSON al modelo pedido
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Error de decodificación:", error)   // ayuda a depurar; quítalo al final
            throw APIError.decodingError
        }
    }
}
