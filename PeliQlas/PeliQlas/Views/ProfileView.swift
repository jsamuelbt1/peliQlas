import SwiftUI
import SwiftData

struct ProfileView: View {

    // El nombre se guarda en el dispositivo y sigue ahí al reabrir la app.
    @AppStorage("profileName") private var profileName = "Álex"

    // Para mostrar cuántas favoritas hay guardadas.
    @Query private var favorites: [FavoriteMovie]

    var body: some View {
        Form {
            // Avatar con la inicial del nombre
            Section {
                HStack {
                    Spacer()
                    Text(String(profileName.prefix(1)).uppercased())
                        .font(.largeTitle).bold()
                        .frame(width: 90, height: 90)
                        .background(Color.red.opacity(0.25))
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                    Spacer()
                }
                .listRowBackground(Color.clear)
            }

            Section("Nombre del perfil") {
                TextField("Tu nombre", text: $profileName)
            }

            Section("Mi colección") {
                LabeledContent("Películas favoritas", value: "\(favorites.count)")
            }
        }
        .navigationTitle("Perfil")
    }
}
