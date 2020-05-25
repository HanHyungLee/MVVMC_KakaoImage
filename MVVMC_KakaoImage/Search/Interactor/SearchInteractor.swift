//
//  SearchInteractor.swift
//  MVVMC_KakaoImage
//
//  Created by Hanhyung Lee on 2020/05/25.
//  Copyright © 2020 Hanhyung Lee. All rights reserved.
//

import Foundation
import RxSwift

protocol SearchInteractorProtocol {
    var rootModel: RootModel { get }
    var didChange$: Observable<RootModel> { get }
    
    func fetchSearch(text: String, page: Int)
}

final class SearchInteractor: SearchInteractorProtocol {
    
    let rootModel: RootModel
    let didChange$: Observable<RootModel>
    
    func fetchSearch(text: String, page: Int) {
        API.imageUrl.fetchImageList(text: <#T##String#>, page: <#T##Int#>, completion: <#T##() -> (Result<RootModel, API.APIError>)#>)
    }
    
    
}
