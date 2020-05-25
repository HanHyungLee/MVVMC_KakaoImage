//
//  SearchInteractor.swift
//  MVVMC_KakaoImage
//
//  Created by Hanhyung Lee on 2020/05/25.
//  Copyright © 2020 Hanhyung Lee. All rights reserved.
//

import Foundation

protocol SearchInteractorProtocol {
    init(text: String)
    
    var rootModel: RootModel { get }
    
    func fetchSearch(text: String, page: Int)
}

final class SearchInteractor: SearchInteractorProtocol {
    
}
