import SwiftUI
import SwiftData

@main
struct PeliQlasApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()   // ya no hay pantalla de bienvenida
                .preferredColorScheme(.dark)
                .modelContainer(for: FavoriteMovie.self)
        }
    }
}
