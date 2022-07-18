
import UIKit
import WebKit

class WebViewController: UIViewController {

    let webView = WKWebView()
    var urlString: String
    
    init(string: String) {
        self.urlString = string
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        guard let url = URL(string: urlString) else {return}
        webView.load(URLRequest(url: url))
        webView.underPageBackgroundColor = .black
        setupNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }

    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.backward"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped))
        
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationController?.hidesBarsOnSwipe = true
    }

    @objc func backButtonTapped(){
        self.dismiss(animated: true)
    }
}
