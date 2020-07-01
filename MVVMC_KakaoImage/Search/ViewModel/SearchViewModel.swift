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
    private let sceneCoordinate: SceneCoordinatorType
    
    private var rootModel: RootModel {
        return searchInteractor.rootModel
    }
    
    // dataSource
    let dataSource$: Driver<[SearchItemViewModel]>
    
    // 최종 합산 데이터
    private var totalData$: BehaviorRelay<[Document]> = .init(value: [])
    // 새로 추가되는 데이터
    private var newData$: BehaviorRelay<NewDocuments> = .init(value: ([], 0))
    
    private let disposeBag: DisposeBag = .init()
    
    // pagenation
    private(set) var currentPage: Int = 0
    
    // meta
    lazy var meta: Meta = {
        return searchInteractor.rootModel.meta
    }()
    
    lazy var isEndPage: Bool = {
        return searchInteractor.rootModel.meta.is_end
    }()
    
    // MARK: - init
    
    init(searchInteractor: SearchInteractorProtocol, coreDataInteractor: CoreDataInteractorProtocol, sceneCoordinate: SceneCoordinatorType) {
        self.searchInteractor = searchInteractor
        self.coreDataInteractor = coreDataInteractor
        self.sceneCoordinate = sceneCoordinate
        
        searchInteractor.didChange$
//            .debug()
            .bind(to: newData$)
            .disposed(by: disposeBag)
        
        newData$
            .debug()
            .withLatestFrom(totalData$) {
                if $0.page == 1 {
                    return $0.documents
                }
                else {
                    return $1 + $0.documents
                }
            }
            .bind(to: totalData$)
            .disposed(by: disposeBag)
        
//        totalData$
//            .subscribe(onNext: { documents in
//                print("documents.count = \(documents.count)")
//            })
//            .disposed(by: disposeBag)
        
        let dataSource$ = totalData$
            .map { documents -> [SearchItemViewModel] in
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
        self.currentPage = page
        searchInteractor.fetchSearch(text: text, page: page, sort: sort, size: size)
    }
    
    func numberOfRows() -> Int {
        return rootModel.documents.count
    }
    
    func saveSearch(indexPath: IndexPath) {
        let document: Document = totalData$.value[indexPath.row]
        coreDataInteractor.saveSearch(document: document)
        reloadData()
    }
    
    func reloadData() {
        totalData$.accept(totalData$.value)
    }
    
    func clear() {
        
    }
    
    func pushToDetail(indexPath: IndexPath, navigationController: UINavigationController?) {
        let searchItem = totalData$.value[indexPath.row].convertSearchItemViewModel()
        let coordinator: DetailCoordinator = .init(navigationController: navigationController)
        let viewModel: DetailViewModel = .init(model: searchItem, coordinator: coordinator)
        let detailScene: Scene = .detial(viewModel)
        sceneCoordinate.transition(to: detailScene, type: .push, animated: true)
    }
}
