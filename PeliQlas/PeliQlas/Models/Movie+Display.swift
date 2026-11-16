import Foundation

// Textos listos para mostrar. Antes cada View armaba su propio String(format:...);
// ahora se define una sola vez y se reutiliza en lista, detalle y Cover Flow.
extension Movie {

    // "2021 • Acción, Aventura"
    var subtitle: String {
        "\(year) • \(genres)"
    }

    // "8.4"
    var ratingText: String {
        String(format: "%.1f", rating)
    }

    // "8.4 / 10"
    var ratingOutOfTenText: String {
        "\(ratingText) / 10"
    }
}
