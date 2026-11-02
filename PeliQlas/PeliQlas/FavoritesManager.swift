import Foundation
import SwiftData

// Concentra la lógica de la colección para no repetirla en cada vista.
// ModelContext es el "cuaderno de trabajo" de SwiftData: aquí se insertan,
// se borran y se guardan los registros.
enum FavoritesManager {

    // ¿Esta película ya está en la colección?
    static func isFavorite(_ movie: Movie, in favorites: [FavoriteMovie]) -> Bool {
        favorites.contains { $0.movieID == movie.id }
    }

    // Agrega la película SOLO si no existe todavía (evita duplicados).
    static func add(_ movie: Movie, favorites: [FavoriteMovie], context: ModelContext) {
        guard !isFavorite(movie, in: favorites) else { return }
        context.insert(FavoriteMovie(from: movie))
        try? context.save()   // guarda en disco
    }

    // Elimina la película de la colección, si está.
    static func remove(_ movie: Movie, favorites: [FavoriteMovie], context: ModelContext) {
        guard let existing = favorites.first(where: { $0.movieID == movie.id }) else { return }
        context.delete(existing)
        try? context.save()
    }

    // Si ya es favorita la quita; si no, la agrega.
    static func toggle(_ movie: Movie, favorites: [FavoriteMovie], context: ModelContext) {
        if isFavorite(movie, in: favorites) {
            remove(movie, favorites: favorites, context: context)
        } else {
            add(movie, favorites: favorites, context: context)
        }
    }
}
