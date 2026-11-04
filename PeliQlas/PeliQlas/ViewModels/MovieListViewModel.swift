//
//  MovieListViewModel.swift
//  PeliQlas
//
//  Created by José Samuel on 02/11/26.
//
import Foundation

// ViewModel de la lista: contiene la LÓGICA de búsqueda, sin nada visual.
// ObservableObject + @Published: la vista se redibuja sola cuando cambian.
class MovieListViewModel: ObservableObject {

    // Texto que el usuario escribe en el buscador.
    @Published var searchText = ""

    // Películas disponibles. Es `private` porque la vista solo debe usar `filteredMovies`.
    private let movies: [Movie]

    // Las películas llegan por el init. Por defecto usa los datos de ejemplo,
    // pero en las pruebas se le pasan datos propios (así el test no depende de nada externo).
    init(movies: [Movie] = Movie.samples) {
        self.movies = movies
    }

    // Regla de negocio que vamos a probar:
    // - Sin texto (o solo espacios) -> todas las películas.
    // - Con texto -> las que contienen ese texto en el título, sin importar mayúsculas.
    var filteredMovies: [Movie] {
        let query = searchText.trimmingCharacters(in: .whitespaces)
        if query.isEmpty {
            return movies
        }
        return movies.filter { $0.title.localizedCaseInsensitiveContains(query) }
    }
}
