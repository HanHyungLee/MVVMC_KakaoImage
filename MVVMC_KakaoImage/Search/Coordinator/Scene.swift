//
//  Scene.swift
//  MVVMC_KakaoImage
//
//  Created by Hanhyung Lee on 2020/06/01.
//  Copyright © 2020 Hanhyung Lee. All rights reserved.
//

import UIKit

enum Tab {
    case scenes([Scene])
}

enum Scene {
    case list(SearchViewModel)
    case favorite(FavoriteViewModel)
}

extension Scene {
    func instantiate(from storyboardName: String = "Main") -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        switch self {
        case .list(let viewModel):
            let nav = storyboard.instantiateViewController(withIdentifier: "SearchNav") as! UINavigationController
            var vc = nav.viewControllers.first as! SearchViewController
            
            vc.bind(viewModel: viewModel)
            
            return vc
        case .favorite(let viewModel):
            let nav = storyboard.instantiateViewController(withIdentifier: "FavoriteNav") as! UINavigationController
            var vc = nav.viewControllers.first as! FavoriteViewController
            
            vc.bind(viewModel: viewModel)
            
            return vc
        }
    }
}
