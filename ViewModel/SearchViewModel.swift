//
//  SearchViewModel.swift
//  NewsApp
//
//  Created by Серафима  Татченкова  on 17.07.2022.
//

import UIKit
import CoreData

class SearchViewModel: NSObject, NSFetchedResultsControllerDelegate {
    
    private let container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    private var fetchedResultController: NSFetchedResultsController<News>?
    
    //retrieve Core Data for SearchNewsTableViewController
    func searchForNewsInCoreData(searchText: String) {
        if let context = self.container?.viewContext {
            let request: NSFetchRequest<News> = News.fetchRequest()
            
            // Sort news
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            
            // Set the order
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
    
    func numberOfRowsInSection(section: Int) -> Int {
        return fetchedResultController?.sections?[section].numberOfObjects ?? 0
    }
    
    func object (indexPath: IndexPath) -> News? {
        return fetchedResultController?.object(at: indexPath)
    }
}
