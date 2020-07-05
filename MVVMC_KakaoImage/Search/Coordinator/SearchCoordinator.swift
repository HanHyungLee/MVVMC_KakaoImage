//
//  SearchCoordinator.swift
//  MVVMC_KakaoImage
//
//  Created by Hanhyung Lee on 2020/07/05.
//  Copyright © 2020 Hanhyung Lee. All rights reserved.
//

import UIKit

protocol SearchCoordinatorProtocol {
    func showDetail(_ cellViewModel: SearchItemCellViewModelProtocol, type: TransitionType)
}

final class SearchCoordinator: SearchCoordinatorProtocol {
    weak var navigationController: UINavigationController?
    
    // MARK: - Public Function
    
    func showDetail(_ cellViewModel: SearchItemCellViewModelProtocol, type: TransitionType) {
        let coordinator = DetailCoordinator(navigationController: navigationController)
        let viewModel: DetailViewModel = .init(model: cellViewModel, coordinator: coordinator)
        let detailScene: Scene = .detial(viewModel)
        
        switch type {
        case .push:
            navigationController?.pushViewController(detailScene.instantiate(), animated: true)
        case .modal:
            navigationController?.present(detailScene.instantiate(), animated: true, completion: nil)
        }
    }
}
