//
//  News+CoreDataProperties.swift
//  NewsApp
//
//  Created by Серафима  Татченкова  on 04.07.2022.
//
//

import Foundation
import CoreData
import UIKit


 


extension News {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News")
    }

    @NSManaged public var pubDate: String
    @NSManaged public var descrip: String
    @NSManaged public var title: String
    @NSManaged public var sourceName: String
    @NSManaged public var image: String
    @NSManaged public var link: String
    @NSManaged public var isSaved: Bool
    
    var cachedRssItem: RSSItem {
       get {
           return RSSItem(sourceName: sourceName, title: title, description: descrip, pubDate: pubDate, image: image, link: link, isSaved: isSaved)
        }
        set {
            self.title = newValue.title
            self.descrip = newValue.description
            self.pubDate = newValue.pubDate
            self.sourceName = newValue.sourceName
            self.link = newValue.link
            self.image = newValue.image
            self.isSaved = newValue.isSaved
        }
     }
}

extension News : Identifiable {

}


