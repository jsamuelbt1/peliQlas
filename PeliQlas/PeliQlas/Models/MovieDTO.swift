import Foundation

// Decodable: permite convertir JSON en estas estructuras con JSONDecoder.
// Los nombres coinciden con el JSON. Como el JSON usa snake_case (release_date),
// el decoder los convierte a camelCase (releaseDate) con .convertFromSnakeCase.
// Los opcionales (?) son campos que la API puede no enviar.

// Respuesta de /movie/popular y /search/movie
struct MovieListResponseDTO: Decodable {
    let page: Int
    let results: [MovieDTO]
}

// Una película dentro de una lista
struct MovieDTO: Decodable, Identifiable {
    let id: Int
    let title: String
    let overview: String?
    let releaseDate: String?
    let voteAverage: Double
    let posterPath: String?
    let genreIds: [Int]?      // NUEVO: ids de género (genre_ids en el JSON)
}

// Respuesta de /movie/{id}?append_to_response=credits
struct MovieDetailDTO: Decodable {
    let id: Int
    let title: String
    let overview: String?
    let releaseDate: String?
    let voteAverage: Double
    let posterPath: String?
    let genres: [GenreDTO]
    let credits: CreditsDTO?
}

struct GenreDTO: Decodable {
    let id: Int
    let name: String
}

struct CreditsDTO: Decodable {
    let cast: [CastDTO]
    let crew: [CrewDTO]
}

struct CastDTO: Decodable {
    let name: String
}

struct CrewDTO: Decodable {
    let name: String
    let job: String    // "Director", "Producer", etc.
}
