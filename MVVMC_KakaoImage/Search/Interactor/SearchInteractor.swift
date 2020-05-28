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
    var didChange$: BehaviorSubject<RootModel> { get }
    
    func fetchSearch(text: String, page: Int)
}

final class SearchInteractor: SearchInteractorProtocol {
    
    private(set) var rootModel: RootModel {
        didSet {
            self.didChange$.onNext(rootModel)
        }
    }
    var didChange$: BehaviorSubject<RootModel> = BehaviorSubject<RootModel>(value: RootModel(documents: [], meta: Meta(is_end: true, pageable_count: 0, total_count: 0)))
    
    private let apiProvider: API
    
    
    init(rootModel: RootModel, apiProvider: API) {
        self.rootModel = rootModel
        self.apiProvider = apiProvider
    }
    
    // MARK: - API
    
    func fetchSearch(text: String, page: Int) {
        apiProvider/*.imageUrl(text: text, page: page, sort: .accuracy, size: 80)*/.fetchImageList(RootModel.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                print("model = \(model)")
                self.rootModel = model
            case .failure(let error):
                print("error = \(error)")
            }
        }
    }
}
