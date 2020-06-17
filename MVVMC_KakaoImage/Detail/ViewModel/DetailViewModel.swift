//
//  DetailViewModel.swift
//  MVVMC_KakaoImage
//
//  Created by Hanhyung Lee on 2020/06/16.
//  Copyright © 2020 Hanhyung Lee. All rights reserved.
//

import Foundation

final class DetailViewModel {
    let model: SearchItemCellViewModelProtocol
    
    init(model: SearchItemCellViewModelProtocol) {
        self.model = model
    }
}
