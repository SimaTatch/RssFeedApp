
import Foundation
import UIKit

class SearchViewController: UITableViewController {
    
    lazy var  pokeSearchController = UISearchController(searchResultsController: nil)
    
    private var viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupNavigationAndSearchBar()
        
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func setupNavigationAndSearchBar() {
        self.navigationItem.searchController = pokeSearchController
        pokeSearchController.searchBar.placeholder = "Search"
        pokeSearchController.searchBar.searchTextField.becomeFirstResponder() // does not work
        pokeSearchController.searchBar.searchTextField.font = UIFont(name: "Poppins-Medium", size: 16)
        pokeSearchController.hidesNavigationBarDuringPresentation = false
        pokeSearchController.obscuresBackgroundDuringPresentation = false
        pokeSearchController.searchResultsUpdater = self
        navigationController?.hidesBarsOnSwipe = false
    }

    //MARK: - SearchTableView delegates
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

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchForNewsInCoreData(searchText: searchController.searchBar.text ?? "")
        self.tableView.reloadData()
    }
}
