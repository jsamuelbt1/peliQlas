import Foundation

// Los 4 estados posibles de la consulta. Es la ÚNICA fuente de verdad:
// no hay variables sueltas como isLoading, errorMessage o movies que se contradigan.
// Solo puede estar en un estado a la vez.
enum ViewState: Equatable {
    case idle                  // aún no se ha consultado
    case loading               // consultando la API
    case loaded([Movie])       // éxito: trae las películas
    case failed(String)        // error: trae el mensaje para el usuario
}

class MovieListViewModel: ObservableObject {

    // private(set): la View puede leerlo pero solo el ViewModel lo modifica.
    @Published private(set) var state: ViewState = .idle

    // Texto del buscador (estado de la interfaz, no de la consulta).
    @Published var searchText = ""

    // El ViewModel depende del PROTOCOLO, no del servicio concreto.
    // En pruebas se le pasa un servicio falso.
    private let service: MovieServiceProtocol

    // Uso normal en la app: empieza en .idle y luego consulta la API.
    init(service: MovieServiceProtocol = MovieService()) {
        self.service = service
    }

    // Para pruebas con datos fijos: empieza ya cargado (tus pruebas actuales usan este).
    init(movies: [Movie], service: MovieServiceProtocol = MovieService()) {
        self.service = service
        self.state = .loaded(movies)
    }

    // Las películas se DERIVAN del estado, no se guardan aparte.
    private var movies: [Movie] {
        if case .loaded(let movies) = state { return movies }
        return []
    }

    // Misma regla de búsqueda de antes (por eso tus pruebas siguen pasando).
    var filteredMovies: [Movie] {
        let query = searchText.trimmingCharacters(in: .whitespaces)
        if query.isEmpty { return movies }
        return movies.filter { $0.title.localizedCaseInsensitiveContains(query) }
    }

    // Carga solo la primera vez. Evita volver a consultar cada vez que se regresa a la lista.
    @MainActor
    func loadIfNeeded() async {
        guard case .idle = state else { return }
        await loadMovies()
    }

    // OPERACIÓN ASÍNCRONA: consulta el servicio y actualiza el estado.
    // @MainActor: se ejecuta en el hilo principal, donde es seguro cambiar
    // lo que la interfaz está mostrando.
    @MainActor
    func loadMovies() async {
        if case .loading = state { return }   // evita consultas duplicadas

        state = .loading
        do {
            let dtos = try await service.fetchPopularMovies()
            // Convierte DTO -> Movie: la View nunca ve el JSON
            state = .loaded(dtos.map { Movie(dto: $0) })
        } catch let error as APIError {
            if case .cancelled = error {
                state = .idle    // la tarea se canceló: se podrá reintentar al volver
            } else {
                state = .failed(error.errorDescription ?? "Error desconocido.")
            }
        } catch {
            state = .failed(APIError.unknown(error).errorDescription ?? "Error desconocido.")
        }
    }
}
