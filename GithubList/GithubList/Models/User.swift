//
//  User.swift
//  GithubList
//
//  Created by kulraj singh on 19/04/25.
//

import Foundation

struct SearchResult: Codable {
    var incompleteResults: Bool?
    var totalCount: Int?
    var items: [User]?
    
    enum CodingKeys: String, CodingKey {
        case incompleteResults = "incomplete_results"
        case totalCount = "total_count"
        case items
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.incompleteResults = try? container.decodeIfPresent(Bool.self, forKey: .incompleteResults)
        self.totalCount = try? container.decodeIfPresent(Int.self, forKey: .totalCount)
        self.items = try? container.decodeIfPresent([User].self, forKey: .items)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.incompleteResults, forKey: .incompleteResults)
        try container.encodeIfPresent(self.totalCount, forKey: .totalCount)
        try container.encodeIfPresent(self.items, forKey: .items)
    }
}

struct User: Codable {
    
    var login: String?
    var id: String?
    var nodeId: String?
    var avatarUrl: String?
    var gravatarId: String?
    var url: String?
    var htmlUrl: String?
    var followersUrl: String?
    var followingUrl: String?
    var gistsUrl: String?
    var starredUrl: String?
    var subscriptionsUrl: String?
    var organizationsUrl: String?
    var reposUrl: String?
    var eventsUrl: String?
    var receivedEventsUrl: String?
    var loginType: String?
    var userViewType: String?
    var isSiteAdmin: Bool?
    var score: Float?
    
    enum CodingKeys: String, CodingKey {
        case login
        case id
        case nodeId = "node_id"
        case avatarUrl = "avatar_url"
        case gravatarId = "gravatar_id"
        case url = "url"
        case htmlUrl = "html_url"
        case followersUrl = "followers_url"
        case followingUrl = "following_url"
        case gistsUrl = "gists_url"
        case starredUrl = "starred_url"
        case subscriptionsUrl = "subscriptions_url"
        case organizationsUrl = "organizations_url"
        case reposUrl = "repos_url"
        case eventsUrl = "events_url"
        case receivedEventsUrl = "received_events_url"
        case loginType = "type"
        case userViewType = "user_view_type"
        case isSiteAdmin = "site_admin"
        case score
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        login = try? container.decode(String.self, forKey: .login)
        id = try? container.decode(String.self, forKey: .id)
        nodeId = try? container.decode(String.self, forKey: .nodeId)
        avatarUrl = try? container.decode(String.self, forKey: .avatarUrl)
        gravatarId = try? container.decode(String.self, forKey: .gravatarId)
        url = try? container.decode(String.self, forKey: .url)
        htmlUrl = try? container.decode(String.self, forKey: .htmlUrl)
        followersUrl = try? container.decode(String.self, forKey: .followersUrl)
        followingUrl = try? container.decode(String.self, forKey: .followingUrl)
        gistsUrl = try? container.decode(String.self, forKey: .gistsUrl)
        starredUrl = try? container.decode(String.self, forKey: .starredUrl)
        subscriptionsUrl = try? container.decode(String.self, forKey: .subscriptionsUrl)
        organizationsUrl = try? container.decode(String.self, forKey: .organizationsUrl)
        reposUrl = try? container.decode(String.self, forKey: .reposUrl)
        userViewType = try? container.decode(String.self, forKey: .userViewType)
        eventsUrl = try? container.decode(String.self, forKey: .eventsUrl)
        receivedEventsUrl = try? container.decode(String.self, forKey: .receivedEventsUrl)
        loginType = try? container.decode(String.self, forKey: .loginType)
        isSiteAdmin = try? container.decode(Bool.self, forKey: .isSiteAdmin)
        score = try? container.decode(Float.self, forKey: .score)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(login, forKey: .login)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(nodeId, forKey: .nodeId)
        try container.encodeIfPresent(avatarUrl, forKey: .avatarUrl)
        try container.encodeIfPresent(gravatarId, forKey: .gravatarId)
        try container.encodeIfPresent(url, forKey: .url)
        try container.encodeIfPresent(login, forKey: .htmlUrl)
        try container.encodeIfPresent(followersUrl, forKey: .followersUrl)
        try container.encodeIfPresent(followingUrl, forKey: .followingUrl)
        try container.encodeIfPresent(gistsUrl, forKey: .gistsUrl)
        try container.encodeIfPresent(starredUrl, forKey: .starredUrl)
        try container.encodeIfPresent(subscriptionsUrl, forKey: .subscriptionsUrl)
        try container.encodeIfPresent(organizationsUrl, forKey: .organizationsUrl)
        try container.encodeIfPresent(reposUrl, forKey: .reposUrl)
        try container.encodeIfPresent(userViewType, forKey: .userViewType)
        try container.encodeIfPresent(eventsUrl, forKey: .eventsUrl)
        try container.encodeIfPresent(receivedEventsUrl, forKey: .receivedEventsUrl)
        try container.encodeIfPresent(loginType, forKey: .loginType)
        try container.encodeIfPresent(isSiteAdmin, forKey: .isSiteAdmin)
        try container.encodeIfPresent(score, forKey: .score)
    }
}
