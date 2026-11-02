import SwiftUI

// Ahora AppState solo guarda el perfil elegido.
// Los favoritos viven en SwiftData (FavoriteMovie).
class AppState: ObservableObject {
    @Published var currentProfile: String = "Álex"
}
