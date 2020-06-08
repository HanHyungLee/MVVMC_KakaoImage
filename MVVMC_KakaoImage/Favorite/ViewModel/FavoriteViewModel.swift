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
    
    var didChange$: Driver<[SearchCoreDataModel]> {
        return coreDataInteractor.didChangeCoreData$.asDriver(onErrorJustReturn: [])
    }
    
    // MARK: - init
    
    init(coreDataInteractor: CoreDataInteractorProtocol) {
        self.coreDataInteractor = coreDataInteractor
    }
    
    
    // MARK: - Public Function
    
    func fetchFavorite() {
        coreDataInteractor.fetchCoreData()
    }
    
    
}
