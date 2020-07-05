//
//  SceneCoordinatorType.swift
//  MVVMC_KakaoImage
//
//  Created by Hanhyung Lee on 2020/06/01.
//  Copyright © 2020 Hanhyung Lee. All rights reserved.
//

import UIKit

enum TransitionType {
    case push
    case modal
}

protocol SceneCoordinatorType {
    func transition(to scene: Scene, type: TransitionType, animated: Bool)
}
