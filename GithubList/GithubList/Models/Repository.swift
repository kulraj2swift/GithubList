//
//  Repository.swift
//  GithubList
//
//  Created by kulraj singh on 20/04/25.
//

import Foundation

struct Repository: Codable {
    var id: Int?
    var name: String?
    var fullName: String?
    var isPrivate: Bool?
    var owner: User?
    var isFork: Bool?
    var language: String?
    var description: String?
    var stargazersCount: Int?
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try? container.decodeIfPresent(Int.self, forKey: .id)
        self.name = try? container.decodeIfPresent(String.self, forKey: .name)
        self.fullName = try? container.decodeIfPresent(String.self, forKey: .fullName)
        self.isPrivate = try? container.decodeIfPresent(Bool.self, forKey: .isPrivate)
        self.owner = try? container.decodeIfPresent(User.self, forKey: .owner)
        self.isFork = try? container.decodeIfPresent(Bool.self, forKey: .isFork)
        self.language = try? container.decodeIfPresent(String.self, forKey: .language)
        self.description = try? container.decodeIfPresent(String.self, forKey: .description)
        self.stargazersCount = try? container.decodeIfPresent(Int.self, forKey: .stargazersCount)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case isPrivate = "private"
        case owner
        case isFork = "fork"
        case language
        case description
        case stargazersCount = "stargazers_count"
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.id, forKey: .id)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.fullName, forKey: .fullName)
        try container.encodeIfPresent(self.isPrivate, forKey: .isPrivate)
        try container.encodeIfPresent(self.owner, forKey: .owner)
        try container.encodeIfPresent(self.isFork, forKey: .isFork)
        try container.encodeIfPresent(self.language, forKey: .language)
        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encodeIfPresent(self.stargazersCount, forKey: .stargazersCount)
    }
}


