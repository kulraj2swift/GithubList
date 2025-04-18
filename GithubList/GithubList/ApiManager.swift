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
}

struct ApiKeys {
    static let resultsPerPage = "per_page"
    static let pageNumber = "page"
}

class ApiManager {
    
    static let shared = ApiManager()
    
    private init() {}
    
    func getHttpHeaders() -> HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(name: "X-GitHub-Api-Version", value: "2022-11-28")
        headers.add(name: "accept", value: "application/json")
        headers.add(name: "Authorization", value: Keys.bearerToken)
        return headers
    }
}
