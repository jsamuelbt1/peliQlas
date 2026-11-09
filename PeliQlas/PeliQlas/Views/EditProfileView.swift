import SwiftUI
import PhotosUI   // PhotosPicker: selector de fotos nativo (no requiere permisos)

struct EditProfileView: View {

    @Environment(\.dismiss) private var dismiss

    @AppStorage("profileName") private var profileName = "Álex"
    @AppStorage("profilePhoto") private var profilePhoto = Data()
    @AppStorage("appearance") private var appearance = "system"

    @State private var selectedItem: PhotosPickerItem?

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(spacing: 12) {
                        ProfileAvatarView(photoData: profilePhoto, name: profileName, size: 110)

                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            Text("Cambiar foto")
                        }

                        if !profilePhoto.isEmpty {
                            Button("Quitar foto", role: .destructive) {
                                profilePhoto = Data()
                            }
                        }
                    }
                    .buttonStyle(.borderless)
                    .frame(maxWidth: .infinity)
                }
                .listRowBackground(Color.clear)

                Section("Nombre") {
                    TextField("Tu nombre", text: $profileName)
                }

                Section("Apariencia") {
                    Picker("Tema", selection: $appearance) {
                        Text("Sistema").tag("system")
                        Text("Claro").tag("light")
                        Text("Oscuro").tag("dark")
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Editar perfil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") { dismiss() }
                }
            }
            // Cuando el usuario elige una foto, se carga, se reduce y se guarda.
            .onChange(of: selectedItem) { _, item in
                guard let item else { return }
                Task {
                    do {
                        if let data = try await item.loadTransferable(type: Data.self),
                           let image = UIImage(data: data),
                           let jpeg = resized(image).jpegData(compressionQuality: 0.8) {
                            profilePhoto = jpeg
                        }
                    } catch {
                        print("No se pudo cargar la foto:", error)
                    }
                }
            }
        }
    }

    // Reduce la imagen a máximo 400 px para que ocupe poco al guardarla.
    private func resized(_ image: UIImage, maxSide: CGFloat = 400) -> UIImage {
        let scale = min(maxSide / max(image.size.width, image.size.height), 1)
        let newSize = CGSize(width: image.size.width * scale,
                             height: image.size.height * scale)
        return UIGraphicsImageRenderer(size: newSize).image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
