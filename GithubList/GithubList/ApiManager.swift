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
    private static let encryptedKey = "de1766d1a0d1cead7275336e02489dd0c35e1b8f21059c866bcddd2bdca77dcbfd3713c7e4fec3c0269bdec9299f610ea01b598c8d48a749b83b18a3f28c606d814b831477349ee28f7e9e89382dfb56c489956b1ab58daae3ce1970cf1a0098"
    private static let key128   = "1234567890123456"                   // 16 bytes for AES128
    private static let key256   = "12345678901234561234567890123456"   // 32 bytes for AES256
    private static let iv       = "abcdefghijklmnop"
    
    static let sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        
        configuration.timeoutIntervalForRequest = 30
        configuration.waitsForConnectivity = true
        configuration.headers = getHttpHeaders()
        
        let aes128 = AES(key: key128, iv: iv)
        let token = aes128?.getPlainText(encryptedText: encryptedKey) ?? ""
        return Session(configuration: configuration, interceptor: RequestInterceptor(storage: token))
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
