import SwiftUI
import SwiftData

struct FavoritesView: View {

    @Environment(\.modelContext) private var modelContext

    // Ordenadas de la más reciente a la más antigua
    @Query(sort: \FavoriteMovie.dateAdded, order: .reverse)
    private var favorites: [FavoriteMovie]

    var body: some View {
        List {
            ForEach(favorites) { favorite in
                NavigationLink {
                    MovieDetailView(movie: favorite.movie)
                } label: {
                    HStack(spacing: 12) {
                        PosterView(imageName: favorite.imageName)
                            .frame(width: 50, height: 75)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        VStack(alignment: .leading) {
                            Text(favorite.title).font(.headline)
                            Text("\(favorite.year) • \(favorite.genres)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            // Deslizar una fila a la izquierda = eliminar de la colección
            .onDelete { offsets in
                for index in offsets {
                    modelContext.delete(favorites[index])
                }
                try? modelContext.save()
            }
        }
        .navigationTitle("Mis favoritas")
        // Mensaje cuando la colección está vacía
        .overlay {
            if favorites.isEmpty {
                ContentUnavailableView("Sin favoritas",
                                       systemImage: "heart",
                                       description: Text("Marca una película con el corazón para guardarla aquí."))
            }
        }
    }
}
