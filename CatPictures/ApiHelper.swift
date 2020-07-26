//
//  ApiHelper.swift
//  CatPictures
//
//  Created by Nadzeya Karaban on 22.07.20.
//  Copyright © 2020 Nadzeya Karaban. All rights reserved.
//

import Alamofire
import Foundation

class ApiHelper: NSObject {
    struct Constants {
        static let scheme = "https"
        static let path = "/v1/images/search"
        static let baseURL = "api.thecatapi.com"
        static let apiKey = "api_key"
        static let apiKeyValue = "7373c180-f8c7-4420-b303-a31cf971acfd"
        static let formatKey = "format"
        static let formatKeyValue = "json"
        static let limitKey = "limit"
        static let limitKeyValue = "10"
        static let pageKey = "page"
        static let pageKeyValue = "1"
        static let methodKey = "method"
        static let getRandomImages = "search"
    }
    
    fileprivate let queryItemKey = URLQueryItem(name: Constants.apiKey, value: Constants.apiKeyValue)
    fileprivate let queryItemFormat = URLQueryItem(name: Constants.formatKey, value: Constants.formatKeyValue)
    fileprivate let queryItemLimit = URLQueryItem(name: Constants.limitKey, value: Constants.limitKeyValue)
    fileprivate let queryItemPage = URLQueryItem(name: Constants.pageKey, value: Constants.pageKeyValue)
    
    var results: [Codable] = []
    var onErrorHandling: ((AFError?) -> Void)?

    var baseURL: URL {
        return URL(string: Constants.baseURL)!
    }
    static let shared = ApiHelper()

    func buildRequestUrl() -> URL {
        var components =
            URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.baseURL
        components.path = Constants.path
        components.queryItems = [
                                 queryItemKey,
                                 queryItemFormat,
                                 queryItemLimit,
                                 queryItemPage]
        return components.url!
    }
    
    func requestPictures<T>( completion: @escaping ([T]) -> Void) {
        let url = self.buildRequestUrl()
        AF.request(url).validate().responseJSON { response in
            guard response.error == nil else {
                print(response.error!)
                return
            }
            guard let data = response.data else {
                return
            }
            do {
                let decoder = JSONDecoder()

                    do {
                        let info = try decoder.decode([CatPicture].self, from: data)
                        self.results = info
                    }

            } catch {
                self.onErrorHandling!(response.error)
            }
            completion(self.results as? [T] ?? [])
        }.resume()
    }
}
