import SwiftUI

// ObservableObject: una clase cuyos cambios "avisan" a todas las vistas que la usan.
// Así el perfil elegido y los favoritos son los MISMOS en todas las pantallas.
class AppState: ObservableObject {

    // @Published: cuando cambia este valor, las vistas se redibujan solas.
    @Published var currentProfile: String = "Álex"

    // Guardamos solo los IDs de las favoritas. Set = colección sin repetidos.
    @Published var favoriteIDs: Set<Int> = []

    // ¿Esta película es favorita?
    func isFavorite(_ movie: Movie) -> Bool {
        favoriteIDs.contains(movie.id)
    }

    // Si ya es favorita la quita; si no, la agrega.
    func toggleFavorite(_ movie: Movie) {
        if favoriteIDs.contains(movie.id) {
            favoriteIDs.remove(movie.id)
        } else {
            favoriteIDs.insert(movie.id)
        }
    }
}
