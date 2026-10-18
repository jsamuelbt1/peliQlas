import SwiftUI

struct MovieDetailView: View {

    // La película llega desde la lista: así se "pasa información" entre vistas.
    let movie: Movie

    @EnvironmentObject var appState: AppState

    // dismiss: acción del sistema que cierra esta pantalla y regresa a la anterior.
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                PosterView(imageName: movie.imageName)
                    .frame(height: 380)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .frame(maxWidth: .infinity)  // centra el póster

                HStack {
                    Text(movie.title).font(.largeTitle).bold()
                    Spacer()
                    Label("\(String(format: "%.1f", movie.rating)) / 10", systemImage: "star.fill")
                        .foregroundStyle(.yellow)
                }

                Text(movie.genres).foregroundStyle(.secondary)

                // Tarjeta con la información
                VStack(alignment: .leading, spacing: 12) {
                    Text("Año de estreno").font(.caption).foregroundStyle(.secondary)
                    Text(String(movie.year)).font(.headline)

                    Text("Director").font(.caption).foregroundStyle(.secondary)
                    Text(movie.director).font(.headline)

                    Text("Actores").font(.caption).foregroundStyle(.secondary)
                    Text(movie.actors).font(.headline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
        // Ocultamos el botón Atrás por defecto para usar nuestra X (como en tu wireframe)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // Corazón a la izquierda: marca/desmarca favorita en el estado compartido
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    appState.toggleFavorite(movie)
                } label: {
                    Image(systemName: appState.isFavorite(movie) ? "heart.fill" : "heart")
                        .foregroundStyle(.red)
                }
            }
            // X a la derecha: regresa a la lista
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
    }
}
