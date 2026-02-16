import Foundation
import UIKit

struct GenerateCardResponse: Decodable {
    let url: String?
    let imageBase64: String?
    let error: String?
}

enum ApiClientError: Error {
    case invalidURL
    case noData
    case serverError(String)
}

enum ApiClient {
    private static func prepareImage(_ image: UIImage, maxDimension: CGFloat = 1024) -> Data? {
        let size = image.size
        let scale: CGFloat
        if max(size.width, size.height) > maxDimension {
            scale = maxDimension / max(size.width, size.height)
        } else {
            scale = 1.0
        }
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let resized = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
        return resized.jpegData(compressionQuality: 0.7)
    }

    static func generateCard(
        image: UIImage,
        cardType: CardType
    ) async throws -> UIImage {
        guard let jpeg = prepareImage(image) else {
            throw ApiClientError.noData
        }
        let base64 = jpeg.base64EncodedString()

        guard let url = URL(string: "\(Config.apiBaseURL)/api/generate-card") else {
            throw ApiClientError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 90
        let body: [String: String] = [
            "imageBase64": base64,
            "cardType": cardType.rawValue,
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw ApiClientError.serverError("Invalid response")
        }

        let decoded = try JSONDecoder().decode(GenerateCardResponse.self, from: data)

        if let error = decoded.error, !error.isEmpty {
            throw ApiClientError.serverError(error)
        }

        if let base64Response = decoded.imageBase64,
           let comma = base64Response.firstIndex(of: ","),
           let imageData = Data(base64Encoded: String(base64Response[base64Response.index(after: comma)...])) {
            if let result = UIImage(data: imageData) {
                return result
            }
        }

        if let urlString = decoded.url, let imageURL = URL(string: urlString) {
            let (imageData, _) = try await URLSession.shared.data(from: imageURL)
            if let result = UIImage(data: imageData) {
                return result
            }
        }

        throw ApiClientError.serverError("No image in response")
    }
}
