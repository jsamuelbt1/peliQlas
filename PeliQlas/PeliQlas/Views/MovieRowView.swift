import SwiftUI

// Fila de una película. Se reutiliza en Populares y en Buscar.
// Solo DIBUJA lo que recibe: no sabe de API ni de favoritos guardados.
struct MovieRowView: View {
    let movie: Movie
    let isFavorite: Bool

    var body: some View {
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

            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundStyle(isFavorite ? .red : .secondary)
        }
    }
}

