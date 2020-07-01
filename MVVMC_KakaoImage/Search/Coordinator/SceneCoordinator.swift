//
//  SceneCoordinator.swift
//  MVVMC_KakaoImage
//
//  Created by Hanhyung Lee on 2020/06/01.
//  Copyright © 2020 Hanhyung Lee. All rights reserved.
//

import UIKit

final class SceneCoordinator: SceneCoordinatorType {
    
    var window: UIWindow
    var mainTabC: UITabBarController!
    var selectedIndex: Int {
        return mainTabC.selectedIndex
    }
    var currentVC: UIViewController {
        return mainTabC.children[mainTabC.selectedIndex].children.last!
    }
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func setTabVC(scenes: [Scene]) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabV = storyboard.instantiateViewController(withIdentifier: "MainTabV") as! UITabBarController
        
        let viewControllers: [UIViewController] = scenes.compactMap {
            return $0.instantiate().navigationController
        }
        
        mainTabV.setViewControllers(viewControllers, animated: false)
        mainTabV.selectedIndex = 0
        
        self.mainTabC = mainTabV
        
        window.rootViewController = mainTabV
        window.makeKeyAndVisible()
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
