import SwiftUI

// Contenedor principal: la barra inferior con las 4 pestañas.
// Cada pestaña tiene su PROPIO NavigationStack, así cada una mantiene
// su pila de pantallas (lista -> detalle) de forma independiente.
struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack { MovieListView() }
                .tabItem { Label("Populares", systemImage: "flame.fill") }

            NavigationStack { FavoritesView() }
                .tabItem { Label("Favoritas", systemImage: "heart.fill") }

            NavigationStack { ProfileView() }
                .tabItem { Label("Perfil", systemImage: "person.fill") }

            NavigationStack { SearchView() }
                .tabItem { Label("Buscar", systemImage: "magnifyingglass") }
        }
        .tint(.red)   // color de la pestaña seleccionada, como en tu referencia
    }
}
