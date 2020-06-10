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
        return searchInteractor.rootModel
    }
    
    lazy var dataSource$: Driver<[SearchItemCellViewModelProtocol]> = {
        return Observable
            .combineLatest(totalData$.asObservable(), newData$.asObserver())
            .map { $0 + $1 }
            .asDriver(onErrorJustReturn: [])
    }()
    
    private var totalData$: BehaviorRelay<[SearchItemViewModel]> = .init(value: [])
    
    private var newData$: PublishSubject<[SearchItemViewModel]> = .init()
    
    lazy var meta: Meta = {
        return searchInteractor.rootModel.meta
    }()
    
    let disposeBag: DisposeBag = .init()
    
    // MARK: - init
    
    init(searchInteractor: SearchInteractorProtocol, coreDataInteractor: CoreDataInteractorProtocol) {
        self.searchInteractor = searchInteractor
        self.coreDataInteractor = coreDataInteractor
        
        bind()
    }
    
    private func bind() {
        searchInteractor.didChange$
            .subscribe(onNext: { [weak self] documents in
                guard let self = self else { return }

                let cellViewModels: [SearchItemViewModel] = documents.map { document -> SearchItemViewModel in
                    let isFavorite: Bool = self.coreDataInteractor.isFavorite(document: document)
                    return SearchItemViewModel(document: document, isFavorite: isFavorite)
                }
                
                self.newData$.onNext(cellViewModels)
            })
            .disposed(by: disposeBag)
    }
    
    
    // MARK: - Public Function
    
    func fetchSearch(text: String, page: Int, sort: API.APISort = .accuracy, size: Int = 80) {
        searchInteractor.fetchSearch(text: text, page: page, sort: sort, size: size)
    }
    
    func numberOfRows() -> Int {
        return rootModel.documents.count
    }
    
    func saveSearch(indexPath: IndexPath) {
        let row: Int = indexPath.row
        let document: Document = rootModel.documents[row]
        coreDataInteractor.saveSearch(document: document)
    }
}
