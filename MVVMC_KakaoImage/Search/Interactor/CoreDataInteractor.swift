//
//  CoreDataInteractor.swift
//  MVVMC_KakaoImage
//
//  Created by Hanhyung Lee on 2020/06/08.
//  Copyright © 2020 Hanhyung Lee. All rights reserved.
//

import UIKit
import CoreData
import RxSwift
import RxCocoa

protocol CoreDataInteractorProtocol {
    var didChangeCoreData$: PublishSubject<[SearchCoreDataModel]> { get }
    
    func saveSearch(document: Document)
    func deleteFavorite(dataModel: SearchCoreDataModel)
    func fetchCoreData()
    func isFavorite(document: Document) -> Bool
}

extension CoreDataInteractor {
    // query
    enum Query {
        case local(collection: String, display_sitename: String, thumbnail_url: String, image_url: String)
        
        func getPredicate() -> NSPredicate {
            switch self {
            case .local(let collection, let display_sitename, let thumbnail_url, let image_url):
                let format: String = """
                    collection == %@ &&
                    display_sitename == %@ &&
                    thumbnail_url == %@ &&
                    image_url == %@
                    """
                
                let predicate = NSPredicate(format: format,
                                            collection,
                                            display_sitename,
                                            thumbnail_url,
                                            image_url)
                return predicate
            }
        }
    }
}

final class CoreDataInteractor: CoreDataInteractorProtocol {
    
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var didChangeCoreData$: PublishSubject<[SearchCoreDataModel]> = PublishSubject<[SearchCoreDataModel]>()
    
    // MARK: - Implement
    
    func saveSearch(document: Document) {
        // core data
        let context = appDelegate.persistentContainer.viewContext
        
        let predicate: NSPredicate =
            Query.local(collection: document.collection,
                        display_sitename: document.display_sitename,
                        thumbnail_url: document.thumbnail_url,
                        image_url: document.image_url)
                .getPredicate()
        
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
                    
                    try context.save()
                }
            }
            else {
                if let first = result.first {
                    let now: Date = Date()
                    first.update_date = now
                    
                    try context.save()
                }
            }
        } catch {
            print("error.localizedDescription = \(error.localizedDescription)")
        }
    }
    
    func deleteFavorite(dataModel: SearchCoreDataModel) {
        let context = appDelegate.persistentContainer.viewContext
        
        let collection: String = dataModel.collection// ?? ""
        let display_sitename: String = dataModel.display_sitename// ?? ""
        let image_url: String = dataModel.image_url// ?? ""
        let thumbnail_url: String = dataModel.thumbnail_url// ?? ""
        let predicate: NSPredicate =
            Query.local(collection: collection,
                        display_sitename: display_sitename,
                        thumbnail_url: thumbnail_url,
                        image_url: image_url)
                .getPredicate()
        
        let fetchRequest = NSFetchRequest<SearchCoreDataModel>(entityName: "SearchCoreDataModel")
        fetchRequest.predicate = predicate
        
        do {
            let searchModels = try context.fetch(fetchRequest)
            searchModels.forEach {
                context.delete($0)
            }
            try context.save()
        } catch {
            print("error.localizedDescription = \(error.localizedDescription)")
        }
    }
    
    func fetchCoreData() {
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let searchModels = try context.fetch(SearchCoreDataModel.fetchRequest()) as! [SearchCoreDataModel]
//                searchModels.forEach {
//                    print($0.display_sitename ?? "")
//                    print($0.image_url ?? "")
//                }
//            return searchModels
            didChangeCoreData$.onNext(searchModels)
        } catch {
            // TODO: error handling
            print("error.localizedDescription = \(error.localizedDescription)")
            didChangeCoreData$.onNext([])
        }
    }
    
    func isFavorite(document: Document) -> Bool {
        let context = appDelegate.persistentContainer.viewContext
        
        let predicate: NSPredicate =
            Query.local(collection: document.collection,
                        display_sitename: document.display_sitename,
                        thumbnail_url: document.thumbnail_url,
                        image_url: document.image_url)
                .getPredicate()
        
        let fetchRequest = NSFetchRequest<SearchCoreDataModel>(entityName: "SearchCoreDataModel")
        fetchRequest.predicate = predicate
        
        do {
            let result = try context.fetch(fetchRequest)
            return result.count > 0
        } catch {
            return false
        }
    }
}
