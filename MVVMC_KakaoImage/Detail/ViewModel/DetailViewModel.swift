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
    let coordinator: DetailCoordinatorProtocol
    
    init(model: SearchItemCellViewModelProtocol, coordinator: DetailCoordinatorProtocol) {
        self.model = model
        self.coordinator = coordinator
    }
}
