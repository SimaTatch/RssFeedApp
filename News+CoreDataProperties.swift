
import Foundation
import CoreData


extension News {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News")
    }

    @NSManaged public var descrip: String?
    @NSManaged public var image: String?
    @NSManaged public var isSaved: Bool
    @NSManaged public var link: String?
    @NSManaged public var pubDate: Date?
    @NSManaged public var sourceName: String?
    @NSManaged public var title: String?

}

extension News : Identifiable {

}
