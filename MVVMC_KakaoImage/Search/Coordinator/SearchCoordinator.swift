//
//  SearchCoordinator.swift
//  MVVMC_KakaoImage
//
//  Created by Hanhyung Lee on 2020/05/25.
//  Copyright © 2020 Hanhyung Lee. All rights reserved.
//

import UIKit

protocol SearchCoordinatorProtocol: class {
    func showSearchList()
}

final class SearchCoordinator: SearchCoordinatorProtocol {
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func showSearchList() {
        // show SearchList
    }
    
}
