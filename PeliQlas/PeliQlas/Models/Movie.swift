import SwiftUI

// Un "modelo" es la estructura que describe los datos de una película.
// Identifiable: permite que SwiftUI distinga cada película en una lista (usa el campo `id`).
// Hashable: permite pasar la película como valor en la navegación (NavigationLink(value:)).
struct Movie: Identifiable, Hashable {
    let id: Int
    let title: String
    let year: Int
    let genres: String
    let rating: Double
    let director: String
    let actors: String
    let imageName: String   // nombre de la imagen en Assets (opcional, ver Paso 8)
}

// Datos de ejemplo (sin API). `static` significa que se accede con Movie.samples
extension Movie {
    static let samples: [Movie] = [
        Movie(id: 1, title: "Dune", year: 2021, genres: "Acción, Aventura",
              rating: 8.4, director: "Denis Villeneuve",
              actors: "Timothée Chalamet, Rebecca Ferguson, Oscar Isaac y Zendaya",
              imageName: "dune"),
        Movie(id: 2, title: "El club de la lucha", year: 1999, genres: "Drama, Thriller",
              rating: 7.8, director: "David Fincher",
              actors: "Brad Pitt, Edward Norton y Helena Bonham Carter",
              imageName: "fightclub"),
        Movie(id: 3, title: "Interstellar", year: 2014, genres: "Ciencia ficción, Drama",
              rating: 8.7, director: "Christopher Nolan",
              actors: "Matthew McConaughey, Anne Hathaway y Jessica Chastain",
              imageName: "interstellar"),
        Movie(id: 4, title: "Parásitos", year: 2019, genres: "Drama, Thriller",
              rating: 8.5, director: "Bong Joon-ho",
              actors: "Song Kang-ho, Lee Sun-kyun y Cho Yeo-jeong",
              imageName: "parasite")
    ]
}
