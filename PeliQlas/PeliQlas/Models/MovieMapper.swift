import Foundation

// Convierte lo que devuelve la API (MovieDTO) en el modelo que usa la app (Movie).
// Así las Views no conocen el formato del JSON.
extension Movie {

    init(dto: MovieDTO) {
        self.init(
            id: dto.id,
            title: dto.title,
            // releaseDate llega como "2021-10-22": tomamos los primeros 4 caracteres
            year: Int(dto.releaseDate?.prefix(4) ?? "") ?? 0,
            genres: Movie.genreNames(for: dto.genreIds ?? []),
            rating: dto.voteAverage,
            // La lista no trae director ni reparto (solo el detalle los trae)
            director: "Sin información",
            actors: "Sin información",
            imageName: "",
            posterURL: dto.posterPath.flatMap { URL(string: APIConfig.imageBaseURL + $0) }
        )
    }

    // Nombres de los géneros de TMDB (los ids son fijos).
    private static let genreDictionary: [Int: String] = [
        28: "Acción", 12: "Aventura", 16: "Animación", 35: "Comedia",
        80: "Crimen", 99: "Documental", 18: "Drama", 10751: "Familia",
        14: "Fantasía", 36: "Historia", 27: "Terror", 10402: "Música",
        9648: "Misterio", 10749: "Romance", 878: "Ciencia ficción",
        10770: "Película de TV", 53: "Suspenso", 10752: "Bélica", 37: "Western"
    ]

    // Muestra máximo 2 géneros, como en tus wireframes ("Acción, Aventura").
    private static func genreNames(for ids: [Int]) -> String {
        ids.compactMap { genreDictionary[$0] }.prefix(2).joined(separator: ", ")
    }
}
