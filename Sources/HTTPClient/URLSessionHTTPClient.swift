//
//  URLSessionHTTPClient.swift
//  OnTheMapMeyer
//
//  Created by Meyer, Gustavo on 5/20/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import Foundation

class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    private struct UnexpectedRepresentation: Error {}

    func makeRequest(from urlResquest: URLRequest, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: urlResquest) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success(data, response))
            } else {
                completion(.failure(UnexpectedRepresentation()))
            }
        }.resume()
    }
}
