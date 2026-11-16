import SwiftUI

struct MainTabView: View {

    // Único ViewModel de las películas populares: lo comparten
    // la pestaña Populares y la vista Cover Flow.
    @StateObject private var popularViewModel = MovieListViewModel()

    var body: some View {
        // GeometryReader mide la pantalla: si es más ancha que alta, está en horizontal.
        GeometryReader { geo in
            let isLandscape = geo.size.width > geo.size.height

            ZStack {
                TabView {
                    NavigationStack { MovieListView(viewModel: popularViewModel) }
                        .tabItem { Label("Populares", systemImage: "flame.fill") }

                    NavigationStack { FavoritesView() }
                        .tabItem { Label("Favoritas", systemImage: "heart.fill") }

                    NavigationStack { ProfileView() }
                        .tabItem { Label("Perfil", systemImage: "person.fill") }

                    NavigationStack { SearchView() }
                        .tabItem { Label("Buscar", systemImage: "magnifyingglass") }
                }
                .tint(.red)

                // Cover Flow encima del TabView solo en horizontal.
                if isLandscape {
                    CoverFlowView(viewModel: popularViewModel)
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut, value: isLandscape)
        }
    }
}
