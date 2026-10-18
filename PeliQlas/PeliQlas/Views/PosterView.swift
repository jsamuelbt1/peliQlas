import SwiftUI

// Vista reutilizable: muestra la imagen del póster si existe en Assets;
// si no, muestra un recuadro gris con un ícono (así la app nunca se ve rota).
struct PosterView: View {
    let imageName: String

    var body: some View {
        if UIImage(named: imageName) != nil {
            Image(imageName)
                .resizable()      // permite cambiar el tamaño
                .scaledToFit()    // mantiene la proporción
        } else {
            ZStack {              // ZStack = elementos uno encima de otro
                Rectangle().fill(Color.gray.opacity(0.3))
                Image(systemName: "film").font(.largeTitle)
            }
        }
    }
}
