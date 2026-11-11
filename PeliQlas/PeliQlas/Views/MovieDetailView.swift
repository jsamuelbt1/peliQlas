import SwiftUI
import SwiftData

struct MovieDetailView: View {

    @StateObject private var viewModel: MovieDetailViewModel
    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [FavoriteMovie]

    // La película llega desde la lista y se entrega al ViewModel.
    init(movie: Movie) {
        _viewModel = StateObject(wrappedValue: MovieDetailViewModel(movie: movie))
    }

    var body: some View {
        let movie = viewModel.movie

        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                PosterView(imageName: movie.imageName, posterURL: movie.posterURL)
                    .frame(height: 380)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .frame(maxWidth: .infinity)

                HStack {
                    Text(movie.title).font(.largeTitle).bold()
                    Spacer()
                    Label("\(String(format: "%.1f", movie.rating)) / 10", systemImage: "star.fill")
                        .foregroundStyle(.yellow)
                }

                Text(movie.genres).foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 12) {
                    infoRow(title: "Año de estreno", value: String(movie.year))
                    infoRow(title: "Director", value: movie.director)
                    infoRow(title: "Actores", value: movie.actors)

                    // Mientras llegan los datos o si falló la consulta
                    if viewModel.isLoading {
                        ProgressView("Cargando director y reparto...")
                            .font(.caption)
                    } else if let message = viewModel.errorMessage {
                        Text(message).font(.caption).foregroundStyle(.red)
                        Button("Reintentar") {
                            Task { await viewModel.loadDetails() }
                        }
                        .font(.caption)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // Corazón en la esquina superior DERECHA.
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // Se guarda viewModel.movie (ya con director y actores completos).
                    FavoritesManager.toggle(movie, favorites: favorites, context: modelContext)
                } label: {
                    Image(systemName: FavoritesManager.isFavorite(movie, in: favorites) ? "heart.fill" : "heart")
                        .foregroundStyle(.red)
                }
            }
        }
        // Pide director y reparto a la API al abrir la pantalla.
        .task { await viewModel.loadDetails() }
    }

    // Fila de información: si el valor está vacío muestra "No disponible".
    private func infoRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title).font(.caption).foregroundStyle(.secondary)
            Text(value.isEmpty ? "No disponible" : value).font(.headline)
        }
    }
}
