//
//  ImageCacheManagerExtensions.swift
//  Amway
//
//  Copyright © 2021 Amway. All rights reserved.
//

import Foundation
import UIKit

extension URLCache {
    static let imageCache = URLCache()

    enum LoadImageError: Error {
        case failedResponse
        case unexpectedError
    }

    @discardableResult
    final func loadImage(url: URL,
                         session: URLSession = URLSession.shared,
                         completion: @escaping (Result<UIImage, Error>) -> Void) -> URLSessionTask?
    {
        let request = URLRequest(url: url)
        if let data = cachedResponse(for: URLRequest(url: url))?.data,
           let image = UIImage(data: data)
        {
            completion(.success(image))
            return nil
        } else {
            let dataTask = session.dataTask(with: request, completionHandler: { [weak self] data, response, _ in
                if let self = self,
                   let data = data,
                   let response = response,
                   ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data)
                {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    self.storeCachedResponse(cachedData, for: request)
                    completion(.success(image))
                } else {
                    completion(.failure(LoadImageError.failedResponse))
                }
            })
            dataTask.resume()
            return dataTask
        }
    }

    @discardableResult
    final func loadGIFData(url: URL,
                           session: URLSession = URLSession.shared,
                           completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask?
    {
        let request = URLRequest(url: url)
        if let data = cachedResponse(for: URLRequest(url: url))?.data {
            completion(.success(data))
            return nil
        } else {
            let dataTask = session.dataTask(with: request, completionHandler: { [weak self] data, response, _ in
                if let self = self,
                   let data = data,
                   let response = response,
                   ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300
                {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    self.storeCachedResponse(cachedData, for: request)
                    completion(.success(data))
                } else {
                    completion(.failure(LoadImageError.failedResponse))
                }
            })
            dataTask.resume()
            return dataTask
        }
    }
}

extension UIImageView {
    enum LoadImageCache {
        typealias LoadResult = (Result<UIImage, Error>) -> Void
    }

    @discardableResult
    func load(url: URL,
              placeholder: UIImage? = nil,
              cache: URLCache = URLCache.imageCache,
              completion: LoadImageCache.LoadResult? = nil) -> URLSessionTask?
    {
        guard let data = cache.cachedResponse(for: URLRequest(url: url))?.data else {
            if let placeholder = placeholder {
                image = placeholder
            }
            return cache.loadImage(url: url) { result in
                switch result {
                case let .success(image):
                    DispatchQueue.main.async { [weak self] in
                        if let self = self {
                            self.image = image
                            completion?(.success(image))
                        } else {
                            completion?(.failure(URLCache.LoadImageError.unexpectedError))
                        }
                    }
                case let .failure(error):
                    completion?(.failure(error))
                }
            }
        }
        image = UIImage(data: data)
        if let image = image {
            completion?(.success(image))
        }
        return nil
    }
}
