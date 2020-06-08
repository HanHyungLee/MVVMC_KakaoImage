//
//  SearchInteractor.swift
//  MVVMC_KakaoImage
//
//  Created by Hanhyung Lee on 2020/05/25.
//  Copyright © 2020 Hanhyung Lee. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SearchInteractorProtocol {
    var rootModel: RootModel { get }
    var didChange$: PublishSubject<[Document]> { get }
    
    func fetchSearch(text: String, page: Int, sort: API.APISort, size: Int)
}

final class SearchInteractor: SearchInteractorProtocol {
    
    private(set) var rootModel: RootModel {
        didSet {
            self.didChange$.onNext(rootModel.documents)
        }
    }
    var didChange$: PublishSubject<[Document]> = .init()
    
//    private let apiProvider: API
    
    
    init(rootModel: RootModel) {
        self.rootModel = rootModel
        self.didChange$.onNext(rootModel.documents)
        
//        let searchModels = fetchCoreData()
//        searchModels.forEach {
//            print("\($0.update_date)")
//            print("\($0.collection)")
//            print("\($0.image_url)")
//        }
    }
    
    // MARK: - API
    
    func fetchSearch(text: String, page: Int, sort: API.APISort = .accuracy, size: Int = 80) {
        API.imageUrl(text: text, page: page, sort: sort, size: size).fetchImageList(RootModel.self) { [weak self] result in
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
