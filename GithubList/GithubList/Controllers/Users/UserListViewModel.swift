//
//  UserListViewModel.swift
//  GithubList
//
//  Created by kulraj singh on 19/04/25.
//

import Foundation
import Alamofire

protocol UserListViewModelDelegate: AnyObject {
    func usersFetched(isSearchTextChanged: Bool)
    func failedtoFetchUsers()
}

class UserListViewModel {
    
    var users: [User] = []
    var sortedUsers: [User] = []
    var apiManager = ApiManager.shared
    weak var delegate: UserListViewModelDelegate?
    private var previousSearchText: String?
    var selectedSortOption: SortOption = .none
    var selectedSortOrder: UserSortOrder = .ascending
    private let pageLimit = 20
    private var pageNumber = 1
    var incompleteResults = false
    
    func searchForUsers(text: String?) {
        var shouldClearPreviousResults = false
        if previousSearchText != text {
            shouldClearPreviousResults = true
        }
        previousSearchText = text
        var query = "?q="
        if let searchText = text,
           searchText.count > 0 {
            query.append("\(searchText)+in:name")
            query.append("&")
        }
        query.append("type:user")
        query.append("&")
        query.append("\(ApiKeys.resultsPerPage)=\(pageLimit)")
        query.append("&")
        query.append("\(ApiKeys.pageNumber)=\(pageNumber)")
        
        var characterSet = CharacterSet.urlQueryAllowed
        characterSet.remove(charactersIn: ":")
        characterSet.insert(charactersIn: "?+=")
        query = query.addingPercentEncoding(withAllowedCharacters: characterSet) ?? ""
        let url = Urls.baseUrl + Urls.searchEndpoint + query
        print("query: \(url)")
        Task {
            let response = await ApiManager.sessionManager.request(url, method: .get)
                .validate()
                .serializingDecodable(SearchResult.self)
                .response
            switch response.result {
            case .success(let searchResult):
                if shouldClearPreviousResults {
                    users.removeAll()
                    pageNumber = 1
                }
                let nextUserBatch = searchResult.items ?? []
                users.append(contentsOf: nextUserBatch)
                incompleteResults = searchResult.incompleteResults ?? false
                applySorting()
                delegate?.usersFetched(isSearchTextChanged: shouldClearPreviousResults)
            case .failure(let error):
                if let data = response.data,
                   let json = try? JSONSerialization.jsonObject(with: data) {
                    print(json)
                }
                incompleteResults = false //since we wont be able to fetch more
                print(error.localizedDescription)
                delegate?.failedtoFetchUsers()
            }
        }
    }
    
    func applySorting() {
        sortedUsers = getSortedUsers()
    }
    
    private func getSortedUsers() -> [User] {
        switch selectedSortOption {
        case .login:
            switch selectedSortOrder {
            case .ascending:
                return users.sorted(by: {
                    if let login = $0.login,
                       let login1 = $1.login {
                        return login < login1
                    }
                    return false
                })
            case .descending:
                return users.sorted(by: {
                    if let login = $0.login,
                       let login1 = $1.login {
                        return login > login1
                    }
                    return false
                })
            }
        case .id:
            switch selectedSortOrder {
            case .ascending:
                return users.sorted(by: {
                    if let id = $0.id,
                       let id1 = $1.id {
                        return id < id1
                    }
                    return false
                })
            case .descending:
                return users.sorted(by: {
                    if let id = $0.id,
                       let id1 = $1.id {
                        return id > id1
                    }
                    return false
                })
            }
        case .none:
            return users
        }
    }
    
    func fetchNextBatch() {
        pageNumber += 1
        searchForUsers(text: previousSearchText)
    }
}
