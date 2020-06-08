//
//  SearchViewModel.swift
//  MVVMC_KakaoImage
//
//  Created by Hanhyung Lee on 2020/05/25.
//  Copyright © 2020 Hanhyung Lee. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel {
    private let searchInteractor: SearchInteractorProtocol
    private let coreDataInteractor: CoreDataInteractorProtocol
    
    private var rootModel: RootModel {
        return self.searchInteractor.rootModel
    }
    
    var didChange$: Driver<[Document]> {
        return self.searchInteractor.didChange$.asDriver(onErrorJustReturn: [])
    }
    
    lazy var meta: Meta = {
        return self.searchInteractor.rootModel.meta
    }()
    
    // MARK: - init
    
    init(searchInteractor: SearchInteractorProtocol, coreDataInteractor: CoreDataInteractorProtocol) {
        self.searchInteractor = searchInteractor
        self.coreDataInteractor = coreDataInteractor
    }
    
    
    // MARK: - Public Function
    
    func fetchSearch(text: String, page: Int, sort: API.APISort = .accuracy, size: Int = 80) {
        self.searchInteractor.fetchSearch(text: text, page: page, sort: sort, size: size)
    }
    
    func numberOfRows() -> Int {
        return self.rootModel.documents.count
    }
    
    func saveSearch(indexPath: IndexPath) {
        let row: Int = indexPath.row
        let document: Document = self.rootModel.documents[row]
        self.coreDataInteractor.saveSearch(document: document)
    }
}
