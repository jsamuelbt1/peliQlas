import Foundation
import SwiftData
import OSLog

// Logger: registra errores en la consola de Xcode en vez de ignorarlos.
private let logger = Logger(subsystem: "PeliQlas", category: "Favorites")

enum FavoritesManager {

    static func isFavorite(_ movie: Movie, in favorites: [FavoriteMovie]) -> Bool {
        favorites.contains { $0.movieID == movie.id }
    }

    static func add(_ movie: Movie, favorites: [FavoriteMovie], context: ModelContext) {
        guard !isFavorite(movie, in: favorites) else { return }
        context.insert(FavoriteMovie(from: movie))
        save(context)
    }

    static func remove(_ movie: Movie, favorites: [FavoriteMovie], context: ModelContext) {
        guard let existing = favorites.first(where: { $0.movieID == movie.id }) else { return }
        context.delete(existing)
        save(context)
    }

    static func toggle(_ movie: Movie, favorites: [FavoriteMovie], context: ModelContext) {
        if isFavorite(movie, in: favorites) {
            remove(movie, favorites: favorites, context: context)
        } else {
            add(movie, favorites: favorites, context: context)
        }
    }

    // Guarda y REGISTRA el error si ocurre, en lugar de silenciarlo.
    private static func save(_ context: ModelContext) {
        do {
            try context.save()
        } catch {
            logger.error("No se pudo guardar: \(error.localizedDescription)")
        }
    }
}
