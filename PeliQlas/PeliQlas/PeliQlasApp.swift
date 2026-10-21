import SwiftUI

@main   // Punto de entrada de la app
struct PeliQlasApp: App {

    // Crea UNA sola instancia del estado compartido
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            // NavigationStack maneja la pila de pantallas
            NavigationStack {
                WelcomeView()   // Pantalla inicial
            }
            .environmentObject(appState)   // Comparte appState con todas las vistas
            .preferredColorScheme(.dark)
        }
    }
}
