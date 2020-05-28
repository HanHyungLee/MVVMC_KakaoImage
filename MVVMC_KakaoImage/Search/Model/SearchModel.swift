//
//  SearchModel.swift
//  MVVMC_KakaoImage
//
//  Created by Hanhyung Lee on 2020/05/25.
//  Copyright © 2020 Hanhyung Lee. All rights reserved.
//

import Foundation

struct RootModel: Codable {
    let documents: [Document]
    let meta: Meta
}

struct Document: Codable, Equatable {
    let collection: String
//    let datetime: Date
    let display_sitename: String
    let doc_url: String
    let height: Int
    let image_url: String
    let thumbnail_url: String
    let width: Int
    
    static func ==(lhs: Document, rhs: Document) -> Bool {
        return lhs.collection == rhs.collection &&
            lhs.image_url == rhs.image_url &&
            lhs.thumbnail_url == rhs.thumbnail_url &&
            lhs.display_sitename == rhs.display_sitename
    }
}

struct Meta: Codable {
    let is_end: Bool
    let pageable_count: Int
    let total_count: Int
}
