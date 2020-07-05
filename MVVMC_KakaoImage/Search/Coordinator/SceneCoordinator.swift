//
//  SceneCoordinator.swift
//  MVVMC_KakaoImage
//
//  Created by Hanhyung Lee on 2020/06/01.
//  Copyright © 2020 Hanhyung Lee. All rights reserved.
//

import UIKit

final class SceneCoordinator: SceneCoordinatorType {
    
    var mainTabC: UITabBarController!
    var selectedIndex: Int {
        return mainTabC.selectedIndex
    }
    var currentVC: UIViewController {
        return mainTabC.children[mainTabC.selectedIndex].children.last!
    }
    
    // MARK: - Public Function
    
    func setRootScene(rootModel: RootModel = RootModel(documents: [], meta: Meta(is_end: true, pageable_count: 0, total_count: 0))) -> UIViewController {
        
        let interactor = SearchInteractor(rootModel: rootModel)
        let coreDataInteractor = CoreDataInteractor()
        let searchCoordinator: SearchCoordinator = .init()
        let searchViewModel = SearchViewModel(searchInteractor: interactor, coreDataInteractor: coreDataInteractor, coordinator: searchCoordinator)
        let searchScene = Scene.list(searchViewModel)
        
        let favoriteCoordinator: FavoriteCoordinator = .init()
        let favoriteViewModel = FavoriteViewModel(coreDataInteractor: coreDataInteractor, coordinator: favoriteCoordinator)
        let favoriteScene = Scene.favorite(favoriteViewModel)
        
        let scenes: [Scene] = [searchScene, favoriteScene]
        let viewControllers: [UIViewController] = scenes.compactMap {
            return $0.instantiate().navigationController
        }
        
        // MainTabBar
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabV = storyboard.instantiateViewController(withIdentifier: "MainTabV") as! UITabBarController
        
        mainTabV.setViewControllers(viewControllers, animated: false)
        mainTabV.selectedIndex = 0
        
        // navigation insert
        searchCoordinator.navigationController = viewControllers[0] as? UINavigationController
        favoriteCoordinator.navigationController = viewControllers[1] as? UINavigationController
        
        self.mainTabC = mainTabV
        return mainTabV
    }
    
    func transition(to scene: Scene, type: TransitionType, animated: Bool) {
        
        let target = scene.instantiate()
        
        switch type {
        case .push:
            let nav = currentVC.navigationController!
            nav.pushViewController(target, animated: animated)
        case .modal:
            currentVC.present(target, animated: true, completion: nil)
        }
    }
    
}
