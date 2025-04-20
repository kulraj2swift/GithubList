//
//  ApiManager.swift
//  GithubList
//
//  Created by kulraj singh on 19/04/25.
//

import Foundation
import Alamofire

struct Urls {
    static let baseUrl = "https://api.github.com/"
    static let searchEndpoint = "search/users"
    static let userEndPoint = "user/"
}

struct ApiKeys {
    static let resultsPerPage = "per_page"
    static let pageNumber = "page"
}

class ApiManager {
    
    static let shared = ApiManager()
    
    static let sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        
        configuration.timeoutIntervalForRequest = 30
        configuration.waitsForConnectivity = true
        configuration.headers = getHttpHeaders()
        
        return Session(configuration: configuration, interceptor: RequestInterceptor(storage: Keys.bearerToken))
    }()
    
    private init() {
        
    }
    
    private static func getHttpHeaders() -> HTTPHeaders {
        var headers: HTTPHeaders = []
        headers.add(name: "X-GitHub-Api-Version", value: "2022-11-28")
        headers.add(name: "accept", value: "application/json")
        
        return headers
    }
}

final class RequestInterceptor: Alamofire.RequestInterceptor {

    private let storage: String

    init(storage: String) {
        self.storage = storage
    }

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping @Sendable (Result<URLRequest, any Error>) -> Void) {
        var urlRequest = urlRequest

        /// Set the Authorization header value using the access token.
        urlRequest.setValue("Bearer " + storage, forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }
}
