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
    
    let dataSource$: Driver<[SearchItemViewModel]>
//    {
//        return items$.asDriver(onErrorJustReturn: [])
//    }
    
    private var items$: BehaviorRelay<[SearchCoreDataModel]> = .init(value: [])
    
    private let disposeBag: DisposeBag = .init()
    
    // MARK: - init
    
    init(coreDataInteractor: CoreDataInteractorProtocol) {
        self.coreDataInteractor = coreDataInteractor
        
        coreDataInteractor.didChangeCoreData$
            .bind(to: items$)
            .disposed(by: disposeBag)
        
        let dataSource$ = items$
            .map({ models -> [SearchItemViewModel] in
                let searchItemViewModels: [SearchItemViewModel] = models.map { model -> SearchItemViewModel in
                    let display_sitename: String = model.display_sitename// ?? ""
                    let image_url: String = model.image_url// ?? ""
                    let searchItemViewModel: SearchItemViewModel = SearchItemViewModel(display_sitename: display_sitename, image_url: image_url, isFavorite: true)
                    return searchItemViewModel
                }
                return searchItemViewModels
            })
            .asDriver(onErrorJustReturn: [])
        
        self.dataSource$ = dataSource$
    }
    
    
    // MARK: - Public Function
    
    func fetchFavorite() {
        coreDataInteractor.fetchCoreData()
    }
    
    func deleteFavorite(_ indexPath: IndexPath) {
        let dataModel = items$.value[indexPath.row]
        coreDataInteractor.deleteFavorite(dataModel: dataModel)
    }
}
