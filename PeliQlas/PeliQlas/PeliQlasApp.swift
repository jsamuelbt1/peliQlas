import SwiftUI

@main   // Indica que aquí empieza la app
struct PeliQlasApp: App {

    // @StateObject: crea UNA sola instancia de AppState que vive mientras la app esté abierta.
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            // NavigationStack: contenedor que maneja la pila de pantallas.
            // Cada pantalla nueva se "apila" y el botón Atrás la quita.
            NavigationStack {
                WelcomeView()   // pantalla inicial
            }
            // Inyecta appState en TODAS las pantallas dentro del stack.
            .environmentObject(appState)
            .preferredColorScheme(.dark) 
        }
    }
}
