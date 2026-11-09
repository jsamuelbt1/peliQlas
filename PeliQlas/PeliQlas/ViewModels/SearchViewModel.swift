import Foundation

// ViewModel de la pestaña Buscar. Reutiliza el enum ViewState (idle, loading,
// loaded, empty, failed), así que hay una sola fuente de verdad del estado.
class SearchViewModel: ObservableObject {

    // Texto que escribe el usuario.
    @Published var query = ""
    @Published private(set) var state: ViewState = .idle

    private let service: MovieServiceProtocol

    init(service: MovieServiceProtocol = MovieService()) {
        self.service = service
    }

    // Se llama desde la View con .task(id: query): cada vez que cambia el texto,
    // SwiftUI CANCELA la tarea anterior y lanza una nueva.
    @MainActor
    func search() async {
        let text = query.trimmingCharacters(in: .whitespaces)

        // Sin texto: volvemos al estado inicial y no consultamos la API.
        guard !text.isEmpty else {
            state = .idle
            return
        }

        // Debounce: espera 0.5 s. Si el usuario sigue escribiendo, esta tarea
        // se cancela aquí y no se hace ninguna llamada innecesaria a la API.
        do {
            try await Task.sleep(for: .milliseconds(500))
        } catch {
            return   // tarea cancelada porque el texto cambió
        }

        state = .loading
        do {
            let dtos = try await service.searchMovies(query: text)
            let movies = dtos.map { Movie(dto: $0) }
            state = movies.isEmpty ? .empty : .loaded(movies)
        } catch let error as APIError {
            if case .cancelled = error { return }   // no es un fallo real
            state = .failed(error.errorDescription ?? "Error desconocido.")
        } catch {
            if error is CancellationError { return }
            state = .failed(APIError.unknown(error).errorDescription ?? "Error desconocido.")
        }
    }
}
