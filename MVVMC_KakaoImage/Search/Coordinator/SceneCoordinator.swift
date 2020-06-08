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
    var currentVC: UIViewController!
    
    init(window: UIWindow) {
        self.window = window
        self.currentVC = window.rootViewController!
    }
    
    func setTabVC(scenes: [Scene]) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabV = storyboard.instantiateViewController(withIdentifier: "MainTabV") as! UITabBarController
        
        let viewControllers: [UIViewController] = scenes.compactMap {
            return $0.instantiate().navigationController
        }
        
        mainTabV.setViewControllers(viewControllers, animated: false)
        mainTabV.selectedIndex = 0
        
        window.rootViewController = mainTabV
        window.makeKeyAndVisible()
    }
    
    func transition(to scene: Scene, type: TransitionType, animated: Bool) {
        
        let target = scene.instantiate()
        
        switch type {
        case .root:
            window.rootViewController = target
            window.makeKeyAndVisible()
            currentVC = target
        case .push:
            let nav = currentVC.navigationController!
            nav.pushViewController(target, animated: animated)
            currentVC = target
        case .modal:
            currentVC.present(target, animated: animated) {
//                self.currentVC = target
            }
            currentVC = target
        default:
            break
        }
    }
    
    func close(animated: Bool) {
        
    }
    
}
