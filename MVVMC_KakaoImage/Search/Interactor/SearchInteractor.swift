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
import CoreData

protocol SearchInteractorProtocol {
    var rootModel: RootModel { get }
    var didChange$: PublishSubject<[Document]> { get }
    
    func fetchSearch(text: String, page: Int, sort: API.APISort, size: Int)
    func saveSearch(document: Document)
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
        
        let searchModels = fetchCoreData()
        searchModels.forEach {
            print("\($0.update_date)")
            print("\($0.collection)")
            print("\($0.image_url)")
        }
    }
    
    private func saveCoreData(document: Document) {
        // core data
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let format: String = """
        collection == %@ &&
        display_sitename == %@ &&
        thumbnail_url == %@ &&
        image_url == %@
        """
        
        let predicate = NSPredicate(format: format,
                                    document.collection,
                                    document.display_sitename,
                                    document.thumbnail_url,
                                    document.image_url)
        let sortDescriptor = NSSortDescriptor(key: "update_date", ascending: false)
        let fetchRequest = NSFetchRequest<SearchCoreDataModel>(entityName: "SearchCoreDataModel")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let result = try context.fetch(fetchRequest)
            if result.count == 0 {
                if let entity = NSEntityDescription.entity(forEntityName: "SearchCoreDataModel", in: context) {
                    let searchModel = NSManagedObject(entity: entity, insertInto: context)
                    searchModel.setValue(document.collection, forKey: "collection")
                    searchModel.setValue(document.display_sitename, forKey: "display_sitename")
                    searchModel.setValue(document.image_url, forKey: "image_url")
                    searchModel.setValue(document.thumbnail_url, forKey: "thumbnail_url")
                    let now: Date = Date()
                    searchModel.setValue(now, forKey: "update_date")
                    print("now = \(now)")
                    
                    try context.save()
                }
            }
            else {
                if let first = result.first {
                    print("이미 존재하는 데이터")
                    let now: Date = Date()
                    first.update_date = now
                    
                    print("now = \(now)")
                    try context.save()
                }
            }
        } catch {
            print("error.localizedDescription = \(error.localizedDescription)")
        }
    }
    
    private func fetchCoreData() -> [SearchCoreDataModel] {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let searchModels = try context.fetch(SearchCoreDataModel.fetchRequest()) as! [SearchCoreDataModel]
//            searchModels.forEach {
//                print($0.display_sitename ?? "")
//                print($0.image_url ?? "")
//            }
            return searchModels
        } catch {
            // TODO: error handling
            print("error.localizedDescription = \(error.localizedDescription)")
            return []
        }
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
    
    // MARK: - Core Data
    
    func saveSearch(document: Document) {
        self.saveCoreData(document: document)
    }
}
