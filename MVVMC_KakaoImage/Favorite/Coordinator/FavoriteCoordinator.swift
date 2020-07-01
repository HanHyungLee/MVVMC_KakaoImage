//
//  FavoriteCoordinator.swift
//  MVVMC_KakaoImage
//
//  Created by Hanhyung Lee on 2020/06/27.
//  Copyright © 2020 Hanhyung Lee. All rights reserved.
//

import UIKit

protocol FavoriteCoordinatorProtocol: class {
    func showDetail(_ cellViewModel: SearchItemCellViewModelProtocol)
}

final class FavoriteCoordinator: FavoriteCoordinatorProtocol {
    
    weak var navigationController: UINavigationController?
    
    func showDetail(_  cellViewModel: SearchItemCellViewModelProtocol) {
        let coordinator = DetailCoordinator(navigationController: navigationController)
        let viewModel: DetailViewModel = .init(model: cellViewModel, coordinator: coordinator)
        let detailScene: Scene = .detial(viewModel)
        navigationController?.pushViewController(detailScene.instantiate(), animated: true)
    }
}
