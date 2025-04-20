//
//  UserDetailsViewModel.swift
//  GithubList
//
//  Created by kulraj singh on 20/04/25.
//

import Foundation
import Alamofire

protocol UserDetailsViewModelDelegate: AnyObject {
    
    func userDetailsFetched()
    func failedToFetchDetails()
}

class UserDetailsViewModel {
    
    weak var delegate: UserDetailsViewModelDelegate?
    var user: User?
    var apiManager = ApiManager.shared
    var repositories: [Repository] = [] {
        didSet {
            onRepositoryFetch?()
        }
    }
    
    var onRepositoryFetch: (() -> ())?
    
    func getUserDetails() {
        guard let userId = user?.id else {
            delegate?.failedToFetchDetails()
            return
        }
        let url = Urls.baseUrl + Urls.userEndPoint + "\(userId)"
        
        Task {
            async let detailResponse = AF.request(url, method: .get, headers: apiManager.getHttpHeaders())
                .validate()
                .serializingDecodable(User.self)
                .response
            async let repositoryListResponse = AF.request(user?.reposUrl ?? "", method: .get, headers: apiManager.getHttpHeaders())
                .validate()
                .serializingDecodable([Repository].self)
                .response
            let userDetailResponse = await detailResponse
            let repositoriesResponse = await repositoryListResponse
            
            switch userDetailResponse.result {
            case .success(let user):
                self.user = user
                delegate?.userDetailsFetched()
            case .failure(let error):
                if let data = userDetailResponse.data,
                   let json = try? JSONSerialization.jsonObject(with: data) {
                    print(json)
                }
                print(error.localizedDescription)
                delegate?.failedToFetchDetails()
            }
            switch repositoriesResponse.result {
            case .success(let repositories):
                //filter for repositories which are not fork
                self.repositories = repositories.filter({
                    if let isFork = $0.isFork,
                       !isFork {
                        return true
                    }
                    return false
                })
            case .failure(let error):
                if let data = userDetailResponse.data,
                   let json = try? JSONSerialization.jsonObject(with: data) {
                    print(json)
                }
                print("Fetch repository failed: " + error.localizedDescription)
            }
        }
    }
}
