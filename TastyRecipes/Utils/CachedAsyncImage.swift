//
//  CachedAsyncImage.swift
//  TastyRecipes
//
//  Created by Abdurrahman Alfudeghi on 05/02/2025.
//

import SwiftUI

struct CachedAsyncImage: View {
    @StateObject private var loader: ImageLoader
    let placeholder: AnyView

    init(url: URL?, placeholder: AnyView = AnyView(ProgressView())) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
        self.placeholder = placeholder
    }

    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                placeholder
            }
        }
        .onAppear {
            loader.load()
        }
    }
}

final class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL?

    init(url: URL?) {
        self.url = url
    }

    func load() {
        guard let url else { return }
        if let cachedImage = ImageCache.shared.image(forKey: url.absoluteString) {
            image = cachedImage
            return
        }
        Task {
            await fetchImage(url: url)
        }
    }

    @MainActor
    private func fetchImage(url: URL) async {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200,
               let uiImg = UIImage(data: data) {
                ImageCache.shared.insertImage(uiImg, forKey: url.absoluteString)
                image = uiImg
            }
        } catch {
            // Handle error
        }
    }
}
