
import UIKit
import CoreData

class CoreDataManager {

    static let sharedInstance = CoreDataManager()
//    private init(){}
    
    let container: NSPersistentContainer? = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let fetchRequest = NSFetchRequest<News>(entityName: "News")
    
    func saveContext() {
        if ((container?.viewContext.hasChanges) != nil) {
            do {
                try container?.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
    
    func saveDataOf(newsRSSArray:[RSSItem]) {
        // Updates Core Data with the new data from the server - Off the main thread
        self.container?.performBackgroundTask { [weak self] (context) in
//            self?.deleteObjectsFromCoreData(context: context)
            self?.saveDataToCoreData(newsRSSArray: newsRSSArray, context: context)
        }
    }
    
    //MARK: - Delete Core Data objects before saving new data
    func deleteObjectsFromCoreData(context: NSManagedObjectContext) {
        do {
            // Fetch Data
            let objects = try context.fetch(fetchRequest)
            
            // Delete Data
            _ = objects.map({context.delete($0)})
            
            // Save Data
            try context.save()
        } catch {
            print("Deleting error \(error)")
        }
    }

    //MARK: - Save new data from the server to Core Data
        private func saveDataToCoreData(newsRSSArray:[RSSItem], context: NSManagedObjectContext) {
        //perform = Make sure that this code of block will be executed on the proper Queue
        //In this case this code should be perform off the main Queue
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        context.perform {
//            print("Arer we on the main Queue? \(String(describing: Thread.isMainThread))")
            for item in newsRSSArray {
                let newsEntity = News(context: context)
                newsEntity.sourceName = item.sourceName
                newsEntity.title = item.title
                newsEntity.descrip = item.description
                newsEntity.pubDate = item.pubDate
                newsEntity.link = item.link
                newsEntity.isSaved = item.isSaved
                newsEntity.image = item.image
            }
            // Save data
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context \(error)")
            }
        }
    }

    func updateItemNEWS (itemToUpdate: String, isSavedUpdated: Bool) {
        let fetchRequest = NSFetchRequest<News>(entityName: "News")
        fetchRequest.predicate = NSPredicate(format: "title == %@", itemToUpdate)
        do {
            let savedRssItems =  try? context.fetch(fetchRequest)
            savedRssItems?.first?.isSaved = isSavedUpdated
            try context.save()
        } catch {
            print("Error in didExit during added endTime")
        }
    }

    func getCertainItemFromCoreData(with name: String) -> News? {
        let fetchRequest = NSFetchRequest<News>(entityName: "News")
        fetchRequest.predicate = NSPredicate(format: "title == %@", name)
        fetchRequest.fetchLimit = 1
        do {
            let fetchedArray = try context.fetch(fetchRequest)
            return fetchedArray.first
        }
        catch {
            //error
            return nil
        }
    }
    
    func getAllItemsFromCoreData() -> [News]? {
        let fetchRequest = NSFetchRequest<News>(entityName: "News")
        do {
            let fetchedArray = try context.fetch(fetchRequest)
            return fetchedArray
        }
        catch {
            //error
            return nil
        }
    }
    
    
//
//    func deleteAllItemsInCoreData(){
//         let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "News")
//         let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
//         do
//         {
//             try context.execute(deleteRequest)
//             try context.save()
//         }
//         catch
//         {
//             print ("There was an error")
//         }
//    }

//
//    func saveRssItemsToCoreData(rssItemsArray: [RSSItem]) {
//        for item in rssItemsArray {
//            do {
//                let news = News(context: context)
//                news.cachedRssItem = item
//                try context.save()
//            }
//            catch {
//                //error
//            }
//        }
//    }
}


