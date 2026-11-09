import SwiftUI
import SwiftData

struct MovieListView: View {

    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = MovieListViewModel()
    @Query private var favorites: [FavoriteMovie]

    var body: some View {
        content
            .navigationTitle("Películas")
            .searchable(text: $viewModel.searchText, prompt: "Buscar películas...")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        FavoritesView()
                    } label: {
                        Image(systemName: "heart.text.square")
                    }
                }
            }
            // .task se ejecuta al aparecer la vista y admite async/await.
            // La View solo dice "carga"; no sabe nada de URLSession.
            .task {
                await viewModel.loadIfNeeded()
            }
    }

    // Qué se dibuja depende SOLO del estado del ViewModel.
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
                Button("Reintentar") {
                    Task { await viewModel.loadMovies() }
                }
            }
        case .empty:
            ContentUnavailableView {
                Label("Sin películas", systemImage: "film")
            } description: {
                Text("La consulta fue exitosa, pero no hay películas para mostrar.")
            } actions: {
                Button("Actualizar") {
                    Task { await viewModel.loadMovies() }
                }
            }

        case .loaded:
            movieList
        }
    }

    private var movieList: some View {
        List {
            Section(header: Text("Hola, \(appState.currentProfile) · Populares")) {
                ForEach(viewModel.filteredMovies) { movie in
                    NavigationLink {
                        MovieDetailView(movie: movie)
                    } label: {
                        HStack(spacing: 12) {
                            PosterView(imageName: movie.imageName, posterURL: movie.posterURL)
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

                            let isFav = FavoritesManager.isFavorite(movie, in: favorites)
                            Image(systemName: isFav ? "heart.fill" : "heart")
                                .foregroundStyle(isFav ? .red : .secondary)
                        }
                    }
                }
            }
        }
        .overlay {
            if viewModel.filteredMovies.isEmpty && !viewModel.searchText.isEmpty {
                ContentUnavailableView.search(text: viewModel.searchText)
        
            }
        }
    }
}
