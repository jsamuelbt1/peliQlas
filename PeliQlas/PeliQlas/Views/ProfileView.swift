import SwiftUI
import SwiftData

// Avatar circular: muestra la foto si existe; si no, la inicial del nombre.
struct ProfileAvatarView: View {
    let photoData: Data
    let name: String
    let size: CGFloat

    var body: some View {
        Group {
            if let image = UIImage(data: photoData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    Color.red.opacity(0.25)
                    Text(String(name.prefix(1)).uppercased())
                        .font(.system(size: size * 0.4, weight: .bold))
                }
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.secondary.opacity(0.4), lineWidth: 1))
    }
}

struct ProfileView: View {

    @AppStorage("profileName") private var profileName = "Álex"
    @AppStorage("profilePhoto") private var profilePhoto = Data()

    // Favoritas, de la más reciente a la más antigua.
    @Query(sort: \FavoriteMovie.dateAdded, order: .reverse)
    private var favorites: [FavoriteMovie]

    @State private var showingEdit = false

    // Cuadrícula que se adapta: ~3 columnas en iPhone.
    private let columns = [GridItem(.adaptive(minimum: 100), spacing: 12)]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // Solo la foto, centrada
                HStack {
                    Spacer()
                    ProfileAvatarView(photoData: profilePhoto, name: profileName, size: 120)
                    Spacer()
                }

                Divider()

                Text("FAVORITAS")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                if favorites.isEmpty {
                    Text("Marca una película con el corazón para verla aquí.")
                        .foregroundStyle(.secondary)
                } else {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(favorites) { favorite in
                            // Tocar una portada abre el detalle
                            NavigationLink {
                                MovieDetailView(movie: favorite.movie)
                            } label: {
                                PosterView(
                                    imageName: favorite.imageName,
                                    posterURL: favorite.posterURLString.flatMap { URL(string: $0) })
                                .aspectRatio(2/3, contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.secondary.opacity(0.3), lineWidth: 1))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)   // sin título "Perfil"
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingEdit = true
                } label: {
                    Image(systemName: "pencil")
                }
            }
        }
        // Hoja emergente para editar
        .sheet(isPresented: $showingEdit) {
            EditProfileView()
        }
    }
}
