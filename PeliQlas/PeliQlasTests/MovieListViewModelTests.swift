import XCTest
@testable import PeliQlas   // permite acceder al código de la app desde las pruebas

final class MovieListViewModelTests: XCTestCase {

    // Datos de prueba FIJOS, escritos aquí mismo: no dependen de API ni de Movie.samples,
    // así el resultado es siempre el mismo (prueba repetible).
    private let testMovies = [
        Movie(id: 1, title: "Dune", year: 2021, genres: "Acción, Aventura",
              rating: 8.4, director: "Director A", actors: "Actor A", imageName: "dune"),
        Movie(id: 2, title: "El club de la lucha", year: 1999, genres: "Drama",
              rating: 7.8, director: "Director B", actors: "Actor B", imageName: "fightclub"),
        Movie(id: 3, title: "Interstellar", year: 2014, genres: "Ciencia ficción",
              rating: 8.7, director: "Director C", actors: "Actor C", imageName: "interstellar")
    ]

    // Función auxiliar: crea un ViewModel nuevo con los datos de prueba.
    private func makeViewModel() -> MovieListViewModel {
        MovieListViewModel(movies: testMovies)
    }

    // CASO NORMAL: buscar un título existente devuelve solo esa película.
    func testSearchWithMatchingTitleReturnsOnlyThatMovie() {
        let viewModel = makeViewModel()

        viewModel.searchText = "Dune"

        XCTAssertEqual(viewModel.filteredMovies.count, 1)
        XCTAssertEqual(viewModel.filteredMovies.first?.title, "Dune")
    }

    // CASO NORMAL (coincidencia parcial): "club" encuentra "El club de la lucha".
    func testSearchWithPartialTextFindsMovie() {
        let viewModel = makeViewModel()

        viewModel.searchText = "club"

        XCTAssertEqual(viewModel.filteredMovies.map { $0.id }, [2])
    }

    // CASO LÍMITE 1: sin texto de búsqueda se devuelven todas las películas.
    func testEmptySearchReturnsAllMovies() {
        let viewModel = makeViewModel()

        viewModel.searchText = ""

        XCTAssertEqual(viewModel.filteredMovies.count, 3)
    }

    // CASO LÍMITE 2: no importan las mayúsculas/minúsculas.
    func testSearchIsCaseInsensitive() {
        let viewModel = makeViewModel()

        viewModel.searchText = "iNtErStElLaR"

        XCTAssertEqual(viewModel.filteredMovies.count, 1)
        XCTAssertEqual(viewModel.filteredMovies.first?.title, "Interstellar")
    }

    // CASO LÍMITE 3: un texto de solo espacios se trata como búsqueda vacía.
    func testSearchWithOnlySpacesReturnsAllMovies() {
        let viewModel = makeViewModel()

        viewModel.searchText = "   "

        XCTAssertEqual(viewModel.filteredMovies.count, 3)
    }

    // CASO SIN RESULTADOS: un título que no existe devuelve una lista vacía.
    func testSearchWithNoMatchReturnsEmptyList() {
        let viewModel = makeViewModel()

        viewModel.searchText = "Titanic"

        XCTAssertTrue(viewModel.filteredMovies.isEmpty)
    }

    // CASO SIN DATOS: un ViewModel sin películas nunca falla, devuelve vacío.
    func testSearchWithNoMoviesReturnsEmptyList() {
        let viewModel = MovieListViewModel(movies: [])

        viewModel.searchText = "Dune"

        XCTAssertEqual(viewModel.filteredMovies.count, 0)
    }
}
