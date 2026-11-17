import SwiftUI

struct MainTabView: View {

    // Único ViewModel de las populares: lo comparten la lista y el Cover Flow.
    @StateObject private var popularViewModel = MovieListViewModel()

    var body: some View {
        // Si es más ancha que alta, el dispositivo está en horizontal.
        GeometryReader { geo in
            let isLandscape = geo.size.width > geo.size.height

            TabView {
                // En horizontal, el contenido de la pestaña cambia a Cover Flow,
                // pero la barra inferior sigue visible.
                Group {
                    if isLandscape {
                        CoverFlowView(viewModel: popularViewModel)
                    } else {
                        NavigationStack { MovieListView(viewModel: popularViewModel) }
                    }
                }
                .tabItem { Label("Populares", systemImage: "flame.fill") }

                Group {
                    if isLandscape {
                        FavoritesCoverFlowView()
                    } else {
                        NavigationStack { FavoritesView() }
                    }
                }
                .tabItem { Label("Favoritas", systemImage: "heart.fill") }

                NavigationStack { ProfileView() }
                    .tabItem { Label("Perfil", systemImage: "person.fill") }

                NavigationStack { SearchView() }
                    .tabItem { Label("Buscar", systemImage: "magnifyingglass") }
            }
            .tint(.red)
        }
    }
}
