import SwiftUI

struct PosterView: View {
    let imageName: String        // imagen local (Assets)
    var posterURL: URL? = nil    // imagen remota (API)

    var body: some View {
        if let posterURL {
            // AsyncImage descarga la imagen por sí sola y avisa en qué fase está.
            AsyncImage(url: posterURL) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFit()
                case .failure:
                    placeholder
                default:
                    ZStack {           // mientras descarga
                        Color.gray.opacity(0.3)
                        ProgressView()
                    }
                }
            }
        } else if UIImage(named: imageName) != nil {
            Image(imageName).resizable().scaledToFit()
        } else {
            placeholder
        }
    }

    private var placeholder: some View {
        ZStack {
            Rectangle().fill(Color.gray.opacity(0.3))
            Image(systemName: "film").font(.largeTitle)
        }
    }
}
