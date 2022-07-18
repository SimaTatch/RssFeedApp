
import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.unselectedItemTintColor = .white
        tabBar.tintColor = .red
        tabBar.backgroundColor = .black
        
        let mainTableVC = NewsMainViewController()
        let savedNewsTableVC = SavedNewsTableViewController(style: .plain)
        let searchVC = SearchViewController()
        
        viewControllers = [
            generateNavigationController(rootViewController: mainTableVC, image: UIImage(systemName: "house")!),
            generateNavigationController(rootViewController: searchVC, image: UIImage(systemName: "magnifyingglass")!),
            generateNavigationController(rootViewController: savedNewsTableVC, image: UIImage(systemName: "bookmark")!)
            
        ]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.imageInsets = UIEdgeInsets(top: 50, left: 0, bottom: -6, right: 0)
        return navigationVC
    }
    

}
