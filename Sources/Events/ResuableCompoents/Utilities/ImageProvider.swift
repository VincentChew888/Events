//
//  ImageProvider.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import UIKit

/// This protocol is made to reduce the redundant implementation for loading images in 'Provider' layer by using the default implementation. Also this protocol helps to achieve the 'Interface Segregation' principle by refactoring the 'ProviderLogic protocol' into smaller protocols.
protocol ImageProvider {
    typealias ImageCompletion = (Result<UIImage, Error>) -> Void
    func loadImage(from urlPath: String, completion: @escaping ImageCompletion)
}

extension ImageProvider {
    /// Default implementation for loadImage method that fetches image from 'URLCache.imageCache' cache.
    /// - Parameters:
    ///   - urlString: Image url path from where image to be fetched
    ///   - completion: Completion handler to handle results
    func loadImage(from urlString: String, completion: @escaping ImageCompletion) {
        guard let url = urlString.encodedURL() else {
            completion(.failure(CommonServiceError.emptyData))
            return
        }
        URLCache.imageCache.loadImage(url: url, completion: completion)
    }
}
