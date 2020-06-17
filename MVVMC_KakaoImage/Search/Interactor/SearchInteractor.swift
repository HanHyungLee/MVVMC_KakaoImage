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

typealias NewDocuments = (documents: [Document], page: Int)

protocol SearchInteractorProtocol {
    var rootModel: RootModel { get }
    var didChange$: PublishSubject<NewDocuments> { get }
    
    func fetchSearch(text: String, page: Int, sort: API.APISort, size: Int)
}

final class SearchInteractor: SearchInteractorProtocol {
    
    private(set) var rootModel: RootModel
//    {
//        didSet {
//            self.didChange$.onNext(rootModel.documents)
//        }
//    }
    var didChange$: PublishSubject<NewDocuments> = .init()
    
    
    // MARK: - init
    
    init(rootModel: RootModel) {
        self.rootModel = rootModel
//        self.didChange$.onNext(rootModel.documents)
    }
    
    // MARK: - API
    
    func fetchSearch(text: String, page: Int, sort: API.APISort = .accuracy, size: Int = 80) {
        API.imageUrl(text: text, page: page, sort: sort, size: size).fetchImageList(RootModel.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
//                print("model = \(model)")
//                self.rootModel = model
                self.setRootModel(rootModel: model, page: page)
            case .failure(let error):
                print("error = \(error)")
            }
        }
    }
    
    // MARK: - Private Function
    
    private func setRootModel(rootModel: RootModel, page: Int) {
        self.rootModel = rootModel
        didChange$.onNext((rootModel.documents, page))
    }
}
