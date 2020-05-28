//
//  SearchCellViewModel.swift
//  MVVMC_KakaoImage
//
//  Created by Hanhyung Lee on 2020/05/28.
//  Copyright © 2020 Hanhyung Lee. All rights reserved.
//

import Foundation

protocol SearchItemCellViewModelProtocol {
    var display_sitename: String { get set }
    var image_url: String { get set }
}

struct SearchItemViewModel: SearchItemCellViewModelProtocol {
    var display_sitename: String
    var image_url: String
}
