//
//  UserListViewModel.swift
//  GithubList
//
//  Created by kulraj singh on 19/04/25.
//

import Foundation
import Alamofire

protocol UserListViewModelDelegate: AnyObject {
    func usersFetched()
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
        var characterSet = CharacterSet.urlQueryAllowed
        characterSet.remove(charactersIn: ":")
        characterSet.insert(charactersIn: "?+=")
        query = query.addingPercentEncoding(withAllowedCharacters: characterSet) ?? ""
        let url = Urls.baseUrl + Urls.searchEndpoint + query
        Task {
            let searchResult = await AF.request(url, method: .get, headers: apiManager.getHttpHeaders())
                .validate()
                .serializingDecodable(SearchResult.self)
                .response
            switch searchResult.result {
            case .success(let searchResult):
                if shouldClearPreviousResults {
                    users.removeAll()
                }
                let nextUserBatch = searchResult.items ?? []
                users.append(contentsOf: nextUserBatch)
                applySorting()
                delegate?.usersFetched()
            case .failure(let error):
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
}
