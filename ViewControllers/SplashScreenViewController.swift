
//import Foundation
//import UIKit
//
//class SplashScreenViewController: UIViewController {
//
//    let feedParser = FeedParser()
//    let urlStringNYT = "https://rss.nytimes.com/services/xml/rss/nyt/World.xml"
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .blue
//        self.view.addSubview(titleLabel)
//        titleLabel.center = self.view.center
//        fetchData()
//
//    }
//
//    public  let titleLabel: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .center
//        label.font = UIFont(name: "Poppins-Medium", size: 20)
//        label.numberOfLines = 0
//        label.textColor = .white
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    private func fetchData() {
//        feedParser.parseFeed(url: urlStringNYT) {(rssItems) in
//            if !rssItems.isEmpty {
//                DispatchQueue.main.async {
//                    CoreDataManager.sharedInstance.saveDataOf(newsRSSArray: rssItems)
//                    let newVC = MainTabBarController()
//                    self.present(newVC, animated: true, completion: nil)
//                }
//
//            } else {
//                self.showAlertWith(title: "Could Not Connect!", message: "Please check your connection")
//            }
//
//        }
//    }
//
//    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
//        let action = UIAlertAction(title: "OK", style: .default) { (action) in
//            self.dismiss(animated: true,completion: nil)
//        }
//        alertController.addAction(action)
//        self.present(alertController, animated: true, completion: nil)
//    }
//}

//let feedURL = URL(string: "https://rss.nytimes.com/services/xml/rss/nyt/World.xml")!
////https://www.themoscowtimes.com/rss/news
////http://images.apple.com/main/rss/hotnews/hotnews.rss
////https://rss.nytimes.com/services/xml/rss/nyt/World.xml
////https://photojournal.jpl.nasa.gov/rss/new
////https://rss.art19.com/apology-line
