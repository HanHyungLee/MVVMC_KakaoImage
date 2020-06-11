//
//  SearchCoreDataModel+CoreDataProperties.swift
//  
//
//  Created by Hanhyung Lee on 2020/06/08.
//
//

import Foundation
import CoreData


extension SearchCoreDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchCoreDataModel> {
        return NSFetchRequest<SearchCoreDataModel>(entityName: "SearchCoreDataModel")
    }

    @NSManaged public var collection: String
    @NSManaged public var display_sitename: String
    @NSManaged public var image_url: String
    @NSManaged public var thumbnail_url: String
    @NSManaged public var update_date: Date

}
