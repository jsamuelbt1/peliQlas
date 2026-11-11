import SwiftUI
import SwiftData

struct MovieListView: View {

    // @AppStorage: guarda el nombre en UserDefaults. Lo edita ProfileView y aquí solo se lee.
    @AppStorage("profileName") private var profileName = "Álex"

    @StateObject private var viewModel = MovieListViewModel()
    @Query private var favorites: [FavoriteMovie]

    var body: some View {
        content
            .navigationTitle("Populares")
            // La View solo dice "carga"; no sabe nada de HTTP.
            .task { await viewModel.loadIfNeeded() }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Cargando películas...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .failed(let message):
            ContentUnavailableView {
                Label("No se pudo cargar", systemImage: "wifi.exclamationmark")
            } description: {
                Text(message)
            } actions: {
                Button("Reintentar") { Task { await viewModel.loadMovies() } }
            }

        case .empty:
            ContentUnavailableView {
                Label("Sin películas", systemImage: "film")
            } description: {
                Text("La consulta fue exitosa, pero no hay películas para mostrar.")
            } actions: {
                Button("Actualizar") { Task { await viewModel.loadMovies() } }
            }

        case .loaded:
            List {
                Section(header: Text("Hola, \(profileName)")) {
                    ForEach(viewModel.filteredMovies) { movie in
                        NavigationLink {
                            MovieDetailView(movie: movie)
                        } label: {
                            MovieRowView(
                                movie: movie,
                                isFavorite: FavoritesManager.isFavorite(movie, in: favorites))
                        }
                    }
                }
            }
            // Jalar hacia abajo para actualizar
            .refreshable { await viewModel.loadMovies() }
        }
    }
}
