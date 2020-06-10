//
//  SearchCellViewModel.swift
//  MVVMC_KakaoImage
//
//  Created by Hanhyung Lee on 2020/05/28.
//  Copyright © 2020 Hanhyung Lee. All rights reserved.
//

import Foundation

protocol SearchItemCellViewModelProtocol {
    var display_sitename: String { get }
    var image_url: String { get }
    var isFavorite: Bool { get set }
}

struct SearchItemViewModel: SearchItemCellViewModelProtocol {
    let display_sitename: String
    let image_url: String
    var isFavorite: Bool
}

extension SearchItemViewModel {
    init(document: Document, isFavorite: Bool) {
        self.display_sitename = document.display_sitename
        self.image_url = document.image_url
        self.isFavorite = isFavorite
    }
}
