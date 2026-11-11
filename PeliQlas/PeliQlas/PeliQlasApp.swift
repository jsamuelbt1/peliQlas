import SwiftUI
import SwiftData

@main
struct PeliQlasApp: App {

    // Preferencia de tema guardada en el dispositivo: "system", "light" o "dark".
    @AppStorage("appearance") private var appearance = "system"

    // nil = usar el tema del sistema.
    private var colorScheme: ColorScheme? {
        switch appearance {
        case "light": return .light
        case "dark": return .dark
        default: return nil
        }
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(colorScheme)
                .modelContainer(for: FavoriteMovie.self)
        }
    }
}
