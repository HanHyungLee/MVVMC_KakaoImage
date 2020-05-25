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
    let datetime: Date
    let display_sitename: String
    let doc_url: URL
    let height: Int
    let image_url: URL
    let thumbnail_url: URL
    let width: Int
    
    static func ==(lhs: Document, rhs: Document) -> Bool {
        return lhs.doc_url == rhs.doc_url ||
            lhs.display_sitename == rhs.display_sitename
    }
}

struct Meta: Codable {
    let is_end: Bool
    let pageable_count: Int
    let total_count: Int
}
