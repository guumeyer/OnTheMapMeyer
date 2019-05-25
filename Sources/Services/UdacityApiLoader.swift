//
//  UdacityApiLoader.swift
//  OnTheMapMeyer
//
//  Created by Meyer, Gustavo on 5/20/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import Foundation

final class UdacityApiLoader: StudentLocationLoader, Authenticaticaion {

    private let serverUrl = "https://onthemap-api.udacity.com/v1"

    private let client: HTTPClient
    private let applicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    private let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"

    public enum Error: LocalizedError {
        case connectivity
        case studentLocationConnectivity
        case httpError(ServerErrorResponse)
        case invalidData

        public var errorDescription: String? {
            switch self {
            case .connectivity:
                return "The internet connection appears to be offline."
            case .studentLocationConnectivity:
                return "There was an error retrieving student data."
            case .httpError(let serverErrorResponse) :
                return serverErrorResponse.error
            case .invalidData:
                return "Invalid data"
            }
        }
    }

    public init(client: HTTPClient) {
        self.client = client
    }
    // MARK: StudentLocationLoader
    func load(completionHandler: @escaping (LoadStudentLocationResult<[StudentLocation]>) -> Void) {
        let limit = URLQueryItem(name: "limit", value: "100")
        let order = URLQueryItem(name: "order", value: "-updatedAt")
        var baseUrl = URLComponents(string: "\(serverUrl)/StudentLocation")!
        baseUrl.queryItems = [limit,order] as [URLQueryItem]

        client.makeRequest(from: makeURLRequest(baseUrl.url!)) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success(data, response):
                completionHandler(UdacityApiLoader.mapStudentLoacations(data, from: response))
            case .failure:
                completionHandler(.failure(Error.studentLocationConnectivity))
            }
        }
    }

    // MARK: Authenticaticaion
    func authorize(credential: UserCredential, completion: @escaping (AuthenticaticaionResult) -> Void) {
        client.makeRequest(from: makeAuthorizeURLRequest(for: credential)) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success(data, response):
                completion(UdacityApiLoader.mapAuthorizeResponse(UdacityApiLoader.clean(data), from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }

    // MAKR: Logoff
    func logoff(completion: @escaping (LogoffResult) -> Void) {
        client.makeRequest(from: makeLogoffURLRequest()) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success(data, response):
                completion(UdacityApiLoader.mapLogoffResponse(UdacityApiLoader.clean(data), from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
//        let session = URLSession.shared
//        let task = session.dataTask(with: request) { data, response, error in
//            if error != nil { // Handle error…
//                return
//            }
//            let range = Range(5..<data!.count)
//            let newData = data?.subdata(in: range) /* subset response data! */
//            print(String(data: newData!, encoding: .utf8)!)
//        }
//        task.resume()
    }

    private static func clean(_ data: Data) -> Data {
        var data = data
        data.removeSubrange(0...4) //subset response data!
        return data
    }

    private func buildUdacityCredentialData(by credential: UserCredential) -> Data {
        return """
            {
            "udacity":{
            "username": "\(credential.userName)",
            "password": "\(credential.password)"
            }
            }
            """.data(using: .utf8)!
    }

    private func makeAuthorizeURLRequest(for credential: UserCredential)  -> URLRequest{
        var request = URLRequest(url: URL(string: "\(serverUrl)/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = buildUdacityCredentialData(by: credential)
        return request
    }

    private func makeLogoffURLRequest() -> URLRequest {
        var request = URLRequest(url: URL(string: "\(serverUrl)/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        return request
    }

    private static func mapAuthorizeResponse(_ data: Data,
                                             from response: HTTPURLResponse) -> AuthenticaticaionResult {
        let decoder = JSONDecoder()
        if response.statusCode == 200, let userSession = try? decoder.decode(UserSession.self, from: data) {
            return .success(userSession)
        }
        do {
            let serverErrorResponse = try decoder.decode(ServerErrorResponse.self, from: data)
            return .failure(Error.httpError(serverErrorResponse))
        } catch {
            return .failure(Error.invalidData)
        }
    }

    private static func mapLogoffResponse(_ data: Data,
                                          from response: HTTPURLResponse) -> LogoffResult{
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter().iso8601())
        if response.statusCode == 200,
            let _ = try? decoder.decode([String:Session].self, from: data) {
            return .success
        }
        do {
            let serverErrorResponse = try decoder.decode(ServerErrorResponse.self, from: data)
            return .failure(Error.httpError(serverErrorResponse))
        } catch {
            return .failure(Error.invalidData)
        }
    }

    private static func mapStudentLoacations(_ data: Data,
                                             from response: HTTPURLResponse) -> LoadStudentLocationResult<[StudentLocation]> {

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter().iso8601())

        guard response.statusCode == 200,
            let studentLocationDic = try? decoder.decode([String: [StudentLocation]].self, from: data),
            let studentLocations = studentLocationDic["results"] else  {
                do {
                    let serverErrorResponse = try decoder.decode(ServerErrorResponse.self, from: data)
                    return .failure(Error.httpError(serverErrorResponse))
                } catch {
                    return .failure(Error.invalidData)
                }
        }

        return .success(studentLocations)
    }

    private func makeURLRequest(_ url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.addValue(applicationId,
                         forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(apiKey,
                         forHTTPHeaderField: "X-Parse-REST-API-Key")
        return request
    }

    // MARK: - ServerErrorResponse
    public struct ServerErrorResponse: Codable {
        let status: Int
        let error: String
    }
}


