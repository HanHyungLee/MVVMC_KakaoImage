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
    
//    lazy var dataSource$: Driver<[SearchItemCellViewModelProtocol]> = {
//        totalData$
//            .map { documents -> [SearchItemViewModel] in
//                print("22documents.count = \(documents.count)")
//                let cellViewModels: [SearchItemViewModel] = documents.map { document -> SearchItemViewModel in
//                    let isFavorite: Bool = self.coreDataInteractor.isFavorite(document: document)
//                    return SearchItemViewModel(document: document, isFavorite: isFavorite)
//                }
//                return cellViewModels
//            }
//            .asDriver(onErrorJustReturn: [])
//    }()
    let dataSource$: Driver<[SearchItemViewModel]>
//    let reloadCell$: PublishSubject<[IndexPath]> = .init()
    
    // 최종 합산 데이터
    private var totalData$: BehaviorRelay<[Document]> = .init(value: [])
    // 새로 추가되는 데이터
    private var newData$: BehaviorRelay<[Document]> = .init(value: [])
    
    lazy var meta: Meta = {
        return searchInteractor.rootModel.meta
    }()
    
    let disposeBag: DisposeBag = .init()
    
    // MARK: - init
    
    init(searchInteractor: SearchInteractorProtocol, coreDataInteractor: CoreDataInteractorProtocol) {
        self.searchInteractor = searchInteractor
        self.coreDataInteractor = coreDataInteractor
        
        searchInteractor.didChange$
//            .debug()
            .bind(to: newData$)
            .disposed(by: disposeBag)
        
        newData$
            .debug()
            .withLatestFrom(totalData$) { $1 + $0 }
            .bind(to: totalData$)
            .disposed(by: disposeBag)
        
        totalData$
            .subscribe(onNext: { documents in
                print("documents.count = \(documents.count)")
            })
            .disposed(by: disposeBag)
        
        let dataSource$ = totalData$
            .map { documents -> [SearchItemViewModel] in
                print("22documents.count = \(documents.count)")
                let cellViewModels: [SearchItemViewModel] = documents.map { document -> SearchItemViewModel in
                    let isFavorite: Bool = coreDataInteractor.isFavorite(document: document)
                    return SearchItemViewModel(document: document, isFavorite: isFavorite)
                }
                return cellViewModels
        }
        .asDriver(onErrorJustReturn: [])
        
        self.dataSource$ = dataSource$
    }
    
    
    // MARK: - Public Function
    
    func fetchSearch(text: String, page: Int, sort: API.APISort = .accuracy, size: Int = 80) {
        searchInteractor.fetchSearch(text: text, page: page, sort: sort, size: size)
    }
    
    func numberOfRows() -> Int {
        return rootModel.documents.count
    }
    
    func saveSearch(indexPath: IndexPath) {
        let document: Document = totalData$.value[indexPath.row]
        coreDataInteractor.saveSearch(document: document)
        totalData$.accept(totalData$.value)
    }
    
    func clear() {
        
    }
}
