import Foundation

// ViewModel del Cover Flow: contiene la LÓGICA de selección, sin nada visual.
// No guarda las películas: las recibe como parámetro desde MovieListViewModel,
// para que haya una sola fuente de verdad de los datos.
class CoverFlowViewModel: ObservableObject {

    // Película centrada en el carrusel (la actualiza el scroll de la View).
    @Published var centeredID: Movie.ID?

    // Película abierta en el panel de detalle. nil = se ve el carrusel.
    // private(set): solo el ViewModel decide cuándo se abre o cierra el detalle.
    @Published private(set) var selectedMovie: Movie?

    // Película actual: la centrada o, si aún no hay ninguna, la primera.
    func currentMovie(in movies: [Movie]) -> Movie? {
        movies.first { $0.id == centeredID } ?? movies.first
    }

    // Regla del toque:
    // - Si tocan la película central, se abre su detalle.
    // - Si tocan una lateral, solo se lleva al centro.
    func handleTap(on movie: Movie, in movies: [Movie]) {
        if currentMovie(in: movies)?.id == movie.id {
            selectedMovie = movie
        } else {
            centeredID = movie.id
        }
    }

    // Cierra el detalle y regresa al carrusel.
    func closeDetail() {
        selectedMovie = nil
    }
}
