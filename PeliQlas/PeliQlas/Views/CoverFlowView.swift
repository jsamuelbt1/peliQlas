import SwiftUI
import SwiftData

struct CoverFlowView: View {

    // Datos: ViewModel compartido con Populares (lo crea MainTabView).
    @ObservedObject var viewModel: MovieListViewModel
    // Lógica de selección: este ViewModel pertenece solo a esta vista.
    @StateObject private var coverFlow = CoverFlowViewModel()
    // Namespace: permite animar el MISMO póster del carrusel al detalle.
    @Namespace private var posterSpace

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
                if let movie = coverFlow.selectedMovie {
                    detail(movie)
                } else {
                    carousel(movies)
                }
            }
        }
        .task { await viewModel.loadIfNeeded() }
    }

    // MARK: - Carrusel

    private func carousel(_ movies: [Movie]) -> some View {
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
                                // La View solo AVISA del toque; la decisión es del ViewModel.
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
                .scrollPosition(id: $coverFlow.centeredID)   // el scroll escribe en el ViewModel
                .frame(height: posterHeight + 20)

                // Título de la película centrada
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
