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
    func fetchCoreData()
    func isFavorite(document: Document) -> Bool
}

final class CoreDataInteractor: CoreDataInteractorProtocol {
    
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var didChangeCoreData$: PublishSubject<[SearchCoreDataModel]> = PublishSubject<[SearchCoreDataModel]>()
    
    func saveSearch(document: Document) {
        // core data
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
