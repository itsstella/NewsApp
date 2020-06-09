//
//  NewsModel.swift
//  NewsApp
//
//  Created by Stella Patricia (ID) on 09/06/20.
//  Copyright © 2020 Stella. All rights reserved.
//

import Foundation
import ObjectMapper

class NewsModel: Mappable {
    var stats: String?
    var totalResults: Int?
    var articles: [ArticlesList]?

    required init?(map: Map) {}

    func mapping(map: Map) {
        stats <- map["status"]
        totalResults <- map["totalResults"]
        articles <- map["articles"]
    }

    class ArticlesList: Mappable {
        var source: SourceData?
        var author: String?
        var title: String?
        var description: String?
        var url: String?
        var urlToImage: String?
        var publishedAt: String?
        var content: String?

        init() {}

        required init?(map: Map) {}

        func mapping(map: Map) {
            source <- map["source"]
            author <- map["author"]
            title <- map["title"]
            description <- map["description"]
            url <- map["url"]
            urlToImage <- map["urlToImage"]
            publishedAt <- map["publishedAt"]
            content <- map["content"]
        }
    }
    
    class SourceData: Mappable {
        var id: String?
        var name: String?
        
        init() {}

        required init?(map: Map) {
            mapping(map: map)
        }

        func mapping(map: Map) {
            id <- map["id"]
            name <- map["name"]
        }
    }
}
