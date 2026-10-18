import SwiftUI

struct MovieListView: View {

    @EnvironmentObject var appState: AppState

    // @State: variable propia de esta vista; al cambiar, la vista se redibuja.
    @State private var searchText = ""

    let movies = Movie.samples

    // Propiedad calculada: si no hay texto muestra todas;
    // si hay, filtra por título (sin importar mayúsculas/minúsculas).
    var filteredMovies: [Movie] {
        if searchText.isEmpty {
            return movies
        }
        return movies.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        List {
            Section(header: Text("Hola, \(appState.currentProfile) · Populares")) {
                ForEach(filteredMovies) { movie in

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
        .searchable(text: $searchText, prompt: "Buscar películas...")
    }
}
