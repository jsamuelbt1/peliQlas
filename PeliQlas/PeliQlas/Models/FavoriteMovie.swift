import Foundation
import SwiftData   // framework de persistencia de Apple

// @Model convierte esta clase en una entidad que SwiftData guarda en disco.
// Debe ser una `class` (no struct).
@Model
final class FavoriteMovie {

    // .unique: SwiftData no permite dos registros con el mismo movieID.
    // Es la primera defensa contra duplicados.
    @Attribute(.unique) var movieID: Int

    var title: String
    var year: Int
    var genres: String
    var rating: Double
    var director: String
    var actors: String
    var imageName: String
    var dateAdded: Date   // cuándo se agregó (sirve para ordenar)
    var posterURLString: String?   // NUEVO (opcional, para no romper datos ya guardados)

    // Crea el registro a partir de una Movie normal.
    init(from movie: Movie) {
        self.movieID = movie.id
        self.title = movie.title
        self.year = movie.year
        self.genres = movie.genres
        self.rating = movie.rating
        self.director = movie.director
        self.actors = movie.actors
        self.imageName = movie.imageName
        self.dateAdded = Date()
        self.posterURLString = movie.posterURL?.absoluteString
    }

    // Convierte el registro guardado de vuelta a Movie,
    // para reutilizar MovieDetailView sin cambiarla.
    var movie: Movie {
        Movie(id: movieID, title: title, year: year, genres: genres,
              rating: rating, director: director, actors: actors,
              imageName: imageName,
              posterURL: posterURLString.flatMap { URL(string: $0) })

    }
}
