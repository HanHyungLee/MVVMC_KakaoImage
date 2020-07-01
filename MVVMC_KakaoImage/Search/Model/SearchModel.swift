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
    let display_sitename: String
    let doc_url: String
    let height: Int
    let image_url: String
    let thumbnail_url: String
    let width: Int
    
    // coreData 용 (이건 밸류타입 변경시 immutable 문제가 되서 추천하지 않는다.)
//    private(set) lazy var isFavorite: Bool = false
    
    static func ==(lhs: Document, rhs: Document) -> Bool {
        return lhs.collection == rhs.collection &&
            lhs.image_url == rhs.image_url &&
            lhs.thumbnail_url == rhs.thumbnail_url &&
            lhs.display_sitename == rhs.display_sitename
    }
}

extension Document {
    func convertSearchItemViewModel() -> SearchItemCellViewModelProtocol {
        let searchItem: SearchItemViewModel = .init(display_sitename: self.display_sitename, image_url: self.image_url, isFavorite: true)
        return searchItem
    }
}

struct Meta: Codable {
    let is_end: Bool
    let pageable_count: Int
    let total_count: Int
}
