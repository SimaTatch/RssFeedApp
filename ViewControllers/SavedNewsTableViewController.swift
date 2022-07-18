

import UIKit
import CoreData

class SavedNewsTableViewController: UITableViewController, UpdateSavedTableViewDelegate {
    
    private var viewModel = SavedNewsListViewModel()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.retrieveSavedNewsFromCoreData()
        self.viewModel.delegate = self
        
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func reloadData(sender: SavedNewsListViewModel) {
        self.tableView.reloadData()
    }
    
    //MARK: - SavedTableView delegates
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = viewModel.object(indexPath: indexPath)
        
        if let newsCell = cell as? NewsTableViewCell {
            if let newsItem = item {
                newsCell.setCellWithValuesOf(newsItem)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = viewModel.object(indexPath: indexPath)
        let webVC = WebViewController(string: item?.link ?? "")
        self.present(UINavigationController(rootViewController: webVC), animated: true, completion: nil)
    }
}
