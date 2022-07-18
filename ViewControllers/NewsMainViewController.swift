
import GoogleMobileAds
import UIKit
import CoreData

class NewsMainViewController: UIViewController, UpdateTableViewDelegate {
    
    let feedParser = FeedParser()
    private var viewModel = NewsListViewModel()

    let urlStringNYT = "https://rss.nytimes.com/services/xml/rss/nyt/World.xml"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
        adsBanner.rootViewController = self
        fetchData()
        
        //Core Data
        loadData()

        setupNavigationBar()
        refreshControlSetup()
        tableViewSetup()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adsBanner.frame = CGRect(x: 0, y: (navigationController?.navigationBar.frame.height)! + 50, width: view.frame.size.width, height: 50).integral
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAlert()
        view.addSubview(adsBanner)
        view.addSubview(newsTableView)
        setupConstraints()
    }

    //MARK: - XMLParser fetchData()
    private func fetchData() {
            feedParser.parseFeed(url: urlStringNYT) {(rssItems) in
                DispatchQueue.main.async {
                    CoreDataManager.sharedInstance.saveDataOf(newsRSSArray: rssItems)
                }
            }
    }
    
    //MARK: - Retrieve data from Core Data
    private func loadData() {
        viewModel.retrieveDataFromCoreData()
    }

    // Update the tableView if changes have been made
    func reloadData(sender: NewsListViewModel) {
        self.newsTableView.reloadData()
    }
    
    //GADBannerView setup
    private let adsBanner: GADBannerView = {
        let banner = GADBannerView()
        banner.adUnitID = "ca-app-pub-2511528698643253/3901182330"
        banner.load(GADRequest())
        banner.backgroundColor = .clear
        return banner
        
    }()

    //MARK: - Check if internet connection is available
    func showAlert() {
        if !InternetReachability.isConnectedToNetwork() {
            let alert = UIAlertController(title: "Warning", message: "The Internet is not available", preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .default) { (action) in
                self.dismiss(animated: true,completion: nil)
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - TableView
    private func tableViewSetup() {
        newsTableView.rowHeight = UITableView.automaticDimension
        newsTableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "Cell")
        newsTableView.backgroundColor = .clear
        newsTableView.dataSource = self
        newsTableView.delegate = self
    }
    
    private var newsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    //MARK: - Pull-to-refresh
    private func refreshControlSetup() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        newsTableView.refreshControl = refreshControl
    }
    
    @objc func refreshTableView(refreshControl: UIRefreshControl) {
        newsTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    //MARK: - NavigationBar
    private func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.title = "Timeline"
        navigationController?.hidesBarsOnSwipe = false
    }
    
    //MARK: - Setup constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            newsTableView.topAnchor.constraint(equalTo: adsBanner.bottomAnchor, constant: 0),
            newsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            newsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            newsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}
    
    //MARK: - MainTableView delegates
    extension NewsMainViewController: UITableViewDataSource, UITableViewDelegate {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.numberOfRowsInSection(section: section)
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

            let item = viewModel.object(indexPath: indexPath)
            if let newsCell = cell as? NewsTableViewCell {
                if let newsItem = item {
                    newsCell.setCellWithValuesOf(newsItem)
                }
            }
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let item = viewModel.object(indexPath: indexPath)
            let webVC = WebViewController(string: item?.link ?? "")
            self.present(UINavigationController(rootViewController: webVC), animated: true, completion: nil)
        }
    }
