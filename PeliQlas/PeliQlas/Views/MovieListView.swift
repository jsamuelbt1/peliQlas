import SwiftUI

struct MovieListView: View {

    @EnvironmentObject var appState: AppState

    // @StateObject: esta vista CREA el ViewModel y lo conserva mientras exista.
    @StateObject private var viewModel = MovieListViewModel()
    
    var body: some View {
        List {
            Section(header: Text("Hola, \(appState.currentProfile) · Populares")) {
                ForEach(viewModel.filteredMovies) { movie in

                    // Al tocar la fila, se apila MovieDetailView y se le pasa la película
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

                            Image(systemName: appState.isFavorite(movie) ? "heart.fill" : "heart")
                                .foregroundStyle(appState.isFavorite(movie) ? .red : .secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Películas")
        .searchable(text: $viewModel.searchText, prompt: "Buscar películas...")
    }
}
