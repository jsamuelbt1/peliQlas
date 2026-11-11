import Foundation

// ViewModel del detalle: pide director y reparto a la API y los combina con la película.
class MovieDetailViewModel: ObservableObject {

    // La película que se muestra. Empieza con los datos de la lista
    // y se completa cuando llega el detalle.
    @Published private(set) var movie: Movie
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let service: MovieServiceProtocol

    init(movie: Movie, service: MovieServiceProtocol = MovieService()) {
        self.movie = movie
        self.service = service
    }

    @MainActor
    func loadDetails() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let dto = try await service.fetchMovieDetail(id: movie.id)
            movie = movie.withDetails(dto)
        } catch let error as APIError {
            if case .cancelled = error { return }
            errorMessage = error.errorDescription
        } catch {
            if error is CancellationError { return }
            errorMessage = APIError.unknown(error).errorDescription
        }
    }
}
