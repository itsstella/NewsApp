//
//  SourcesModel.swift
//  NewsApp
//
//  Created by Stella Patricia (ID) on 09/06/20.
//  Copyright © 2020 Stella. All rights reserved.
//

import Foundation
import ObjectMapper

class SourcesModel: Mappable {
    var stats: String?
    var sources: [SourcesList]?

    required init?(map: Map) {}

    func mapping(map: Map) {
        stats <- map["status"]
        sources <- map["sources"]
    }

    class SourcesList: Mappable {
        var id: String?
        var name: String?
        var description: String?
        var url: String?
        var category: String?
        var language: String?
        var country: String?

        init() {}

        required init?(map: Map) {}

        func mapping(map: Map) {
            id <- map["id"]
            name <- map["name"]
            description <- map["description"]
            url <- map["url"]
            category <- map["category"]
            language <- map["language"]
            country <- map["country"]
        }
    }
}
