//
//  FavoriteViewModel.swift
//  MVVMC_KakaoImage
//
//  Created by Hanhyung Lee on 2020/06/08.
//  Copyright © 2020 Hanhyung Lee. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class FavoriteViewModel {
    let coreDataInteractor: CoreDataInteractorProtocol
    let coordinator: FavoriteCoordinatorProtocol
    
    // dataSource
    let dataSource$: Driver<[SearchItemViewModel]>
    
    // origin data
    private var items$: BehaviorRelay<[SearchCoreDataModel]> = .init(value: [])
    private let disposeBag: DisposeBag = .init()
    
    // MARK: - init
    
    init(coreDataInteractor: CoreDataInteractorProtocol, coordinator: FavoriteCoordinatorProtocol) {
        self.coreDataInteractor = coreDataInteractor
        self.coordinator = coordinator
        
        coreDataInteractor.didChangeCoreData$
            .bind(to: items$)
            .disposed(by: disposeBag)
        
        let dataSource$ = items$
            .map({ models -> [SearchItemViewModel] in
                let searchItemViewModels: [SearchItemViewModel] = models.map { model -> SearchItemViewModel in
                    let display_sitename: String = model.display_sitename
                    let image_url: String = model.image_url
                    let searchItemViewModel: SearchItemViewModel = SearchItemViewModel(display_sitename: display_sitename, image_url: image_url, isFavorite: true)
                    return searchItemViewModel
                }
                return searchItemViewModels
            })
            .asDriver(onErrorJustReturn: [])
        
        self.dataSource$ = dataSource$
    }
    
    
    // MARK: - Public Function
    
    func getItem(indexPath: IndexPath) -> SearchCoreDataModel {
        return items$.value[indexPath.row]
    }
    
    func fetchFavorite() {
        coreDataInteractor.fetchCoreData()
    }
    
    func deleteFavorite(_ indexPath: IndexPath) {
        let dataModel = items$.value[indexPath.row]
        coreDataInteractor.deleteFavorite(dataModel: dataModel)
    }
    
    func showDetail(_ indexPath: IndexPath) {
        let searchItem = items$.value[indexPath.row].convertSearchItemViewModel()
        coordinator.showDetail(searchItem)
//        let searchItem = items$.value[indexPath.row].convertSearchItemViewModel()
//        let coordinator: DetailCoordinator = DetailCoordinator(navigationController: navigationCon)
//        let viewModel: DetailViewModel = .init(model: searchItem, coordinator: coordinator)
//        let detailScene: Scene = .detial(viewModel)
//        coordinator.transition(to: detailScene, type: .push, animated: true)
    }
}
