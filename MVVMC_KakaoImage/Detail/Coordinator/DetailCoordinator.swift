//
//  DetailCoordinator.swift
//  MVVMC_KakaoImage
//
//  Created by Hanhyung Lee on 2020/06/27.
//  Copyright © 2020 Hanhyung Lee. All rights reserved.
//

import UIKit

protocol DetailCoordinatorProtocol: class {
    
}

final class DetailCoordinator: DetailCoordinatorProtocol {
     
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
}
