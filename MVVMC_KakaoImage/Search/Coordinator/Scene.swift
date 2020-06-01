//
//  Scene.swift
//  MVVMC_KakaoImage
//
//  Created by Hanhyung Lee on 2020/06/01.
//  Copyright © 2020 Hanhyung Lee. All rights reserved.
//

import UIKit

enum Scene {
    case list(SearchViewModel)
    case favorite
}

extension Scene {
    func instantiate(from storyboardName: String = "Main") -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        switch self {
        case .list(let viewModel):
            let mainTabV = storyboard.instantiateViewController(withIdentifier: "MainTabV") as! UITabBarController
            let nav = mainTabV.viewControllers?.first as! UINavigationController
            var vc = nav.viewControllers.first as! SearchViewController
            
            vc.bind(viewModel: viewModel)
            
            return mainTabV
        case .favorite:
            fatalError()
        }
    }
}
