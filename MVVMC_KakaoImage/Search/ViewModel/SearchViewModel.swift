//
//  SearchViewModel.swift
//  MVVMC_KakaoImage
//
//  Created by Hanhyung Lee on 2020/05/25.
//  Copyright © 2020 Hanhyung Lee. All rights reserved.
//

import Foundation

final class SearchViewModel {
    private let searchInteractor: SearchInteractorProtocol
    
    private var rootModel: RootModel {
        return self.searchInteractor.rootModel
    }
    
    // MARK: - init
    
    init(searchInteractor: SearchInteractorProtocol) {
        self.searchInteractor = searchInteractor
    }
    
    
    // MARK: - Public Function
    
    func fetchSearch(text: String, page: Int) {
        self.searchInteractor.fetchSearch(text: text, page: page)
    }
    
    func numberOfRows() -> Int {
        return self.rootModel.documents.count
    }
}
