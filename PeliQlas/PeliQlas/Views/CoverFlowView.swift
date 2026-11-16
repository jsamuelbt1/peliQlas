import SwiftUI
import SwiftData

// COMPONENTE REUTILIZABLE: carrusel + detalle para CUALQUIER lista de películas.
// No sabe de dónde vienen (API o favoritas): solo recibe `movies`.
struct CoverFlowBrowser: View {

    let movies: [Movie]
    // Lógica de selección: cada pantalla tiene su propia instancia.
    @StateObject private var coverFlow = CoverFlowViewModel()
    @Namespace private var posterSpace

    var body: some View {
        if let movie = coverFlow.selectedMovie {
            detail(movie)
        } else {
            carousel
        }
    }

    // MARK: - Carrusel

    private var carousel: some View {
        GeometryReader { geo in
            let posterHeight = geo.size.height * 0.62
            let posterWidth = posterHeight * 2 / 3

            VStack(spacing: 16) {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: -posterWidth * 0.3) {
                        ForEach(movies) { movie in
                            PosterView(imageName: movie.imageName, posterURL: movie.posterURL)
                                .frame(width: posterWidth, height: posterHeight)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .shadow(radius: 8)
                                .matchedGeometryEffect(id: movie.id, in: posterSpace)
                                .scrollTransition(axis: .horizontal) { content, phase in
                                    content
                                        .rotation3DEffect(.degrees(phase.value * -55),
                                                          axis: (x: 0, y: 1, z: 0),
                                                          perspective: 0.5)
                                        .scaleEffect(phase.isIdentity ? 1 : 0.85)
                                }
                                .onTapGesture {
                                    withAnimation(.spring(duration: 0.5)) {
                                        coverFlow.handleTap(on: movie, in: movies)
                                    }
                                }
                        }
                    }
                    .scrollTargetLayout()
                }
                .contentMargins(.horizontal, (geo.size.width - posterWidth) / 2,
                                for: .scrollContent)
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $coverFlow.centeredID)
                .frame(height: posterHeight + 20)

                if let current = coverFlow.currentMovie(in: movies) {
                    VStack(spacing: 2) {
                        Text(current.title).font(.headline)
                        Text(current.subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    // MARK: - Detalle (póster a la izquierda, información a la derecha)

    private func detail(_ movie: Movie) -> some View {
        HStack(spacing: 24) {
            PosterView(imageName: movie.imageName, posterURL: movie.posterURL)
                .aspectRatio(2 / 3, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 10)
                .matchedGeometryEffect(id: movie.id, in: posterSpace)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            CoverFlowDetailPanel(movie: movie) {
                withAnimation(.spring(duration: 0.5)) { coverFlow.closeDetail() }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
    }
}

// POPULARES: maneja los estados de la consulta y delega el dibujo al componente.
struct CoverFlowView: View {

    @ObservedObject var viewModel: MovieListViewModel

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            switch viewModel.state {
            case .idle, .loading:
                ProgressView("Cargando películas...")

            case .failed(let message):
                ContentUnavailableView {
                    Label("No se pudo cargar", systemImage: "wifi.exclamationmark")
                } description: {
                    Text(message)
                } actions: {
                    Button("Reintentar") { Task { await viewModel.loadMovies() } }
                }

            case .empty:
                ContentUnavailableView("Sin películas", systemImage: "film")

            case .loaded(let movies):
                CoverFlowBrowser(movies: movies)
            }
        }
        .task { await viewModel.loadIfNeeded() }
    }
}

// FAVORITAS: lee la colección de SwiftData y usa el mismo componente.
struct FavoritesCoverFlowView: View {

    // Más reciente primero. Se actualiza sola al agregar o quitar favoritas.
    @Query(sort: \FavoriteMovie.dateAdded, order: .reverse)
    private var favorites: [FavoriteMovie]

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            if favorites.isEmpty {
                ContentUnavailableView(
                    "Sin favoritas",
                    systemImage: "heart",
                    description: Text("Marca una película con el corazón para verla aquí."))
            } else {
                // FavoriteMovie.movie la convierte a Movie, que es lo que espera el componente.
                CoverFlowBrowser(movies: favorites.map { $0.movie })
            }
        }
    }
}
// Panel derecho: reutiliza MovieDetailViewModel para traer director, actores y sinopsis.
struct CoverFlowDetailPanel: View {

    @StateObject private var viewModel: MovieDetailViewModel
    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [FavoriteMovie]
    let onClose: () -> Void

    init(movie: Movie, onClose: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: MovieDetailViewModel(movie: movie))
        self.onClose = onClose
    }

    var body: some View {
        let movie = viewModel.movie

        VStack(alignment: .leading, spacing: 8) {
            // Barra superior: volver al carrusel y favorito
            HStack {
                Button { onClose() } label: {
                    Label("Volver", systemImage: "chevron.left")
                }
                Spacer()
                Button {
                    FavoritesManager.toggle(movie, favorites: favorites, context: modelContext)
                } label: {
                    Image(systemName: FavoritesManager.isFavorite(movie, in: favorites)
                          ? "heart.fill" : "heart")
                        .foregroundStyle(.red)
                }
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text(movie.title).font(.title).bold()

                    HStack {
                        Text("\(movie.year) • \(movie.genres)").foregroundStyle(.secondary)
                        Spacer()
                        Label(String(format: "%.1f / 10", movie.rating), systemImage: "star.fill")
                            .foregroundStyle(.yellow)
                    }

                    infoRow(title: "Director", value: movie.director)
                    infoRow(title: "Actores", value: movie.actors)
                    infoRow(title: "Sinopsis", value: movie.overview)

                    if viewModel.isLoading {
                        ProgressView().controlSize(.small)
                    } else if let message = viewModel.errorMessage {
                        Text(message).font(.caption).foregroundStyle(.red)
                        Button("Reintentar") { Task { await viewModel.loadDetails() } }
                            .font(.caption)
                    }
                }
            }
        }
        .task { await viewModel.loadDetails() }
    }

    private func infoRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title).font(.caption).foregroundStyle(.secondary)
            Text(value.isEmpty ? "No disponible" : value).font(.subheadline)
        }
    }
}
