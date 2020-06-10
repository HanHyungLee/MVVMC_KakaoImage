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
    
//    private var didChange$: PublishSubject<[SearchCoreDataModel]> {
//        return coreDataInteractor.didChangeCoreData$
//    }
    
    // MARK: - init
    
    init(coreDataInteractor: CoreDataInteractorProtocol) {
        self.coreDataInteractor = coreDataInteractor
        
        let dataSource$ = coreDataInteractor.didChangeCoreData$
            .map({ models -> [SearchItemViewModel] in
               let searchItemViewModels: [SearchItemViewModel] = models.map { model -> SearchItemViewModel in
                    let display_sitename: String = model.display_sitename ?? ""
                    let image_url: String = model.image_url ?? ""
                    let searchItemViewModel: SearchItemViewModel = SearchItemViewModel(display_sitename: display_sitename, image_url: image_url, isFavorite: true)
                    return searchItemViewModel
                }
                return searchItemViewModels
            })
            .share()
            .asDriver(onErrorJustReturn: [])
        
        self.dataSource$ = dataSource$
    }
    
    
    // MARK: - Public Function
    
    func fetchFavorite() {
        coreDataInteractor.fetchCoreData()
    }
    
    
}
