import SwiftUI

struct WelcomeView: View {

    // @EnvironmentObject: toma el AppState que inyectamos en PeliQlasApp.
    @EnvironmentObject var appState: AppState

    let profiles = ["Álex", "Lucía"]

    var body: some View {
        VStack(spacing: 28) {   // VStack = elementos en vertical

            Text("peliQlas")
                .font(.largeTitle).bold()

            Text("Elige tu perfil y empieza la función.")
                .foregroundStyle(.secondary)

            // HStack = elementos en horizontal
            HStack(spacing: 24) {
                // ForEach recorre el arreglo y crea un botón por perfil
                ForEach(profiles, id: \.self) { name in
                    Button {
                        // Guardamos el perfil en el estado COMPARTIDO
                        appState.currentProfile = name
                    } label: {
                        VStack {
                            Text(String(name.prefix(1)))   // primera letra
                                .font(.title).bold()
                                .frame(width: 76, height: 76)
                                .background(Color.gray.opacity(0.25))
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                                .overlay(
                                    // Borde cian solo en el perfil seleccionado
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(appState.currentProfile == name ? Color.cyan : Color.clear,
                                                lineWidth: 3)
                                )
                            Text(name)
                        }
                    }
                    .buttonStyle(.plain)  // quita el color azul por defecto del botón
                }
            }

            // NavigationLink: al tocarlo, APILA la pantalla MovieListView.
            // Esa pantalla recibe automáticamente el botón "Atrás".
            NavigationLink {
                MovieListView()
            } label: {
                Text("Entrar como \(appState.currentProfile)")  // \( ) inserta una variable en el texto
                    .font(.headline)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.cyan)
                    .clipShape(Capsule())
            }
            .padding(.horizontal)
        }
        .padding()
    }
}
