import SwiftUI
import SwiftData

struct SearchView: View {

    @StateObject private var viewModel = SearchViewModel()
    @Query private var favorites: [FavoriteMovie]

    var body: some View {
        content
            .navigationTitle("Buscar")
            .searchable(text: $viewModel.query, prompt: "Buscar películas...")
            // .task(id:) se relanza cada vez que cambia el texto.
            .task(id: viewModel.query) {
                await viewModel.search()
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            ContentUnavailableView("Busca una película",
                                   systemImage: "magnifyingglass",
                                   description: Text("Escribe un título para buscar en el catálogo."))

        case .loading:
            ProgressView("Buscando...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .empty:
            ContentUnavailableView.search(text: viewModel.query)

        case .failed(let message):
            ContentUnavailableView {
                Label("No se pudo buscar", systemImage: "wifi.exclamationmark")
            } description: {
                Text(message)
            } actions: {
                Button("Reintentar") { Task { await viewModel.search() } }
            }

        case .loaded(let movies):
            List(movies) { movie in
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
}
