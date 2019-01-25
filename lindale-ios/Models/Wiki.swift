//
//  Wiki.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/12/12.
//  Copyright © 2018 lindelin. All rights reserved.
//

import Moya
import UIKit

struct WikiType: Codable {
    var id: Int
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    static func resources(project: ProjectCollection.Project, completion: @escaping ([WikiType]?) -> Void) {
        NetworkProvider.main.data(request: .projectWikiTypes(project: project)) { (data) in
            guard let data = data else {
                completion(nil)
                return
            }
            
            let wikiTypes = try! JSONDecoder.main.decode([WikiType].self, from: data)
            completion(wikiTypes)
        }
    }
}

struct Wiki: Codable {
    var id: Int
    var title: String
    var content: String
    var originalContent: String
    var image: URL?
    var user: User
    var project: Int
    var updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case originalContent = "original_content"
        case image
        case user
        case project
        case updatedAt = "updated_at"
    }
    
    static func resources(project: ProjectCollection.Project, type: WikiType, completion: @escaping ([Wiki]?) -> Void) {
        NetworkProvider.main.data(request: .projectWikis(project: project, type: type)) { (data) in
            guard let data = data else {
                completion(nil)
                return
            }
            
            let wikis = try! JSONDecoder.main.decode([Wiki].self, from: data)
            completion(wikis)
        }
    }
    
    static func find(id: Int, completion: @escaping (Wiki?) -> Void) {
        NetworkProvider.main.data(request: .wikiDetail(id: id)) { (data) in
            guard let data = data else {
                completion(nil)
                return
            }
            
            let wiki = try! JSONDecoder.main.decode(Wiki.self, from: data)
            completion(wiki)
        }
    }
}

struct WikiRegister {
    var id: Int?
    var title: String?
    var content: String?
    var typeId: Int?
    var image: UIImage?
    var projectId: Int?
    
    func update(completion: @escaping ([String: String]) -> Void) {
        NetworkProvider.main.message(request: .updateWiki(wiki: self)) { (status) in
            completion(status)
        }
    }
    
    func store(completion: @escaping ([String: String]) -> Void) {
        NetworkProvider.main.message(request: .storeWiki(wiki: self)) { (status) in
            completion(status)
        }
    }
}

struct WikiTypeRegister {
    var id: Int?
    var name: String?
    var projectId: Int?
    
    func store(completion: @escaping ([String: String]) -> Void) {
        NetworkProvider.main.message(request: .storeWikiType(wikiType: self)) { (status) in
            completion(status)
        }
    }
}
