//
//  ReusableView.swift
//  MVVMC_KakaoImage
//
//  Created by Hanhyung Lee on 2020/06/02.
//  Copyright © 2020 Hanhyung Lee. All rights reserved.
//

import UIKit

protocol ReusableView: class {
    static var reuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
