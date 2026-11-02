import SwiftUI
import SwiftData

struct MovieListView: View {

    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = MovieListViewModel()

    // @Query: lee los favoritos guardados y la vista se actualiza sola
    // cada vez que la colección cambia.
    @Query private var favorites: [FavoriteMovie]

    var body: some View {
        List {
            Section(header: Text("Hola, \(appState.currentProfile) · Populares")) {
                ForEach(viewModel.filteredMovies) { movie in
                    NavigationLink {
                        MovieDetailView(movie: movie)
                    } label: {
                        HStack(spacing: 12) {
                            PosterView(imageName: movie.imageName)
                                .frame(width: 60, height: 90)
                                .clipShape(RoundedRectangle(cornerRadius: 8))

                            VStack(alignment: .leading, spacing: 4) {
                                Text(movie.title).font(.headline)
                                Text("\(movie.year) • \(movie.genres)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Label(String(format: "%.1f", movie.rating), systemImage: "star.fill")
                                    .font(.caption)
                                    .foregroundStyle(.yellow)
                            }

                            Spacer()

                            // Corazón según lo que hay guardado en SwiftData
                            let isFav = FavoritesManager.isFavorite(movie, in: favorites)
                            Image(systemName: isFav ? "heart.fill" : "heart")
                                .foregroundStyle(isFav ? .red : .secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Películas")
        .searchable(text: $viewModel.searchText, prompt: "Buscar películas...")
        .toolbar {
            // Acceso a la colección personal
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    FavoritesView()
                } label: {
                    Image(systemName: "heart.text.square")
                }
            }
        }
    }
}
