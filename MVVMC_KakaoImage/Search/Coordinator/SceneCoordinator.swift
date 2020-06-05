//
//  SceneCoordinator.swift
//  MVVMC_KakaoImage
//
//  Created by Hanhyung Lee on 2020/06/01.
//  Copyright © 2020 Hanhyung Lee. All rights reserved.
//

import UIKit

final class SceneCoordinator: SceneCoordinatorType {
    
    var window: UIWindow!
    var currentVC: UIViewController!
    
    init(window: UIWindow) {
        self.window = window
        self.currentVC = window.rootViewController!
    }
    
    func transition(to scene: Scene, type: TransitionType, animated: Bool) {
        
        let target = scene.instantiate()
        
        switch type {
        case .root:
            self.window.rootViewController = target
            self.window.makeKeyAndVisible()
            self.currentVC = target
        case .push:
            let nav = self.currentVC.navigationController!
            nav.pushViewController(target, animated: animated)
            self.currentVC = target
        case .modal:
            self.currentVC.present(target, animated: animated) {
//                self.currentVC = target
            }
            self.currentVC = target
        default:
            break
        }
    }
    
    func close(animated: Bool) {
        
    }
    
}
