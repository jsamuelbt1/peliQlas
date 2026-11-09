import Foundation

// Todos los errores posibles de la comunicación con la API en un solo tipo.
// LocalizedError: permite que `error.localizedDescription` devuelva un mensaje
// legible que luego se puede mostrar al usuario.
enum APIError: Error, LocalizedError {
    case invalidURL                    // no se pudo construir la URL
    case noConnection                  // sin internet
    case timeout                       // el servidor tardó demasiado
    case cancelled                     // la tarea fue cancelada
    case invalidResponse               // la respuesta no es HTTP
    case httpError(statusCode: Int)    // código fuera de 200-299 (401, 404, 500...)
    case decodingError                 // el JSON no coincide con el modelo
    case unknown(Error)                // cualquier otro error

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "La dirección de la solicitud no es válida."
        case .noConnection:
            return "Sin conexión a internet. Revisa tu red e inténtalo de nuevo."
        case .timeout:
            return "El servidor tardó demasiado en responder."
        case .cancelled:
            return "La solicitud fue cancelada."
        case .invalidResponse:
            return "La respuesta del servidor no es válida."
        case .httpError(let code):
            return "El servidor respondió con un error (código \(code))."
        case .decodingError:
            return "No se pudo interpretar la información recibida."
        case .unknown(let error):
            return "Ocurrió un error inesperado: \(error.localizedDescription)"
        }
    }
}
