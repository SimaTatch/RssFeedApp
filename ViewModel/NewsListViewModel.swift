
import Foundation
import UIKit
import CoreData

protocol UpdateTableViewDelegate: NSObjectProtocol {
    func reloadData(sender: NewsListViewModel)
}

class NewsListViewModel: NSObject, NSFetchedResultsControllerDelegate {
    
    private let container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    private var fetchedResultController: NSFetchedResultsController<News>?
    
    weak var delegate: UpdateTableViewDelegate?

    // retrieve all Core Data for main tableView
    func retrieveDataFromCoreData() {
        if let context = self.container?.viewContext {
            let request: NSFetchRequest<News> = News.fetchRequest()
            

            request.sortDescriptors = [NSSortDescriptor(key: #keyPath(News.pubDate), ascending: false)]
            self.fetchedResultController = NSFetchedResultsController(fetchRequest: request,
                                                                      managedObjectContext: context,
                                                                      sectionNameKeyPath: nil,
                                                                      cacheName: nil)

            // Notifies the tableView when any changes have occured to the data
            fetchedResultController?.delegate = self
            
            //Fetch data
            do {
                try self.fetchedResultController?.performFetch()
            } catch {
                print("Failed to initialize FetchedResultsController: \(error)")
            }
        }
    }
   
    // Changes have happened in fetchedResultsController so we need to notify the tableView
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // Update the tableView
        self.delegate?.reloadData(sender: self)
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return fetchedResultController?.sections?[section].numberOfObjects ?? 0
    }
    
    func object (indexPath: IndexPath) -> News? {
        return fetchedResultController?.object(at: indexPath)
    }
}
