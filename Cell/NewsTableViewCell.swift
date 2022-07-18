
import UIKit

class NewsTableViewCell: UITableViewCell{
    
    var newsItem: News?

    let largeConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .light, scale: .small)
    var isSaved: Bool?
    
    private var imageDownload = DownloadImage()
    private var viewModel = NewsListViewModel()
    
    private var fetchedLink: String = ""
    private var fetchedImage: String = ""

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = true
        self.backgroundColor = .clear
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        setupViews()
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Setup news value
    func setCellWithValuesOf(_ news: News) {
        updateUI(title: news.title, description: news.descrip, date: news.pubDate, link: news.link, sourceName: news.sourceName, isSaved: news.isSaved, image: news.image)
    }
    
    //MARK: - Update the UI Views
    private func updateUI(title: String?, description: String?, date: Date?, link: String?, sourceName: String?, isSaved: Bool?, image: String?) {
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        self.isSaved = isSaved
        self.saveButton.setImage(changeSaveButtonAppearance(isSaved: isSaved ?? false), for: .normal)
        self.fetchedLink = link ?? ""
        if let currentDate = date {
            let timeAgo = currentDate.timeAgoDisplay()
            self.dateLabel.text = "\(sourceName ?? "Unknown source")・\(timeAgo)"
        } else {
            self.dateLabel.text = "\(sourceName ?? "Unknown source")・date is not defined"
        }
        guard let imageString = image else {return}
        fetchedImage = imageString
        guard let url = URL(string: fetchedImage) else {return}
        self.newsImageView.image = nil
        imageDownload.fetchImage(url: url) { [weak self] (fetchedImage) in
            if let newImage = fetchedImage {
                self?.newsImageView.image = newImage
            } else {
                self?.newsImageView.image = UIImage(named: "image1")
            }
        }
    }
    
    //MARK: - Button is pressed func
    @objc func saveButtonPressed(sender: UIButton) {
        isSaved?.toggle()
        CoreDataManager.sharedInstance.updateItemNEWS(itemToUpdate: titleLabel.text ?? "", isSavedUpdated: isSaved ?? false)
        sender.setImage(changeSaveButtonAppearance(isSaved: isSaved ?? false), for: .normal)
    }
    
    //MARK: - Change button image if item isSaved
    private func changeSaveButtonAppearance(isSaved: Bool) -> UIImage {
        return isSaved ? UIImage(systemName: "bookmark.fill", withConfiguration: largeConfig)! : UIImage(systemName: "bookmark", withConfiguration: largeConfig)!
    }
    
    //MARK: - UI
    public  let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.minimumScaleFactor = 0.3
        label.font = UIFont(name: "Poppins-Medium", size: 16)
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.minimumScaleFactor = 0.3
        label.font = UIFont(name: "Poppins-ExtraBold", size: 16)
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let newsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.alignment = .fill
//        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    public let dateLabel: UILabel = {
        let label = UILabel()
        label.minimumScaleFactor = 0.3
        label.font = UIFont(name: "Poppins-Medium", size: 13)
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let saveButton: UIButton = {
        let button = UIButton()
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public let littleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - Views setup/ Constraints setup
    private func setupViews() {
        self.addSubview(littleStackView)
        self.addSubview(titleLabel)
        self.addSubview(newsStackView)
    }
    
    private func addSubviews() {
        littleStackView.addArrangedSubview(dateLabel)
        littleStackView.addArrangedSubview(saveButton)

        newsStackView.addArrangedSubview(newsImageView)
        newsStackView.addArrangedSubview(descriptionLabel)

    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            saveButton.widthAnchor.constraint(equalToConstant: 25.5),
            saveButton.heightAnchor.constraint(equalToConstant: 26.5)
        ])
        
        NSLayoutConstraint.activate([
            littleStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            littleStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            littleStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ])

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: littleStackView.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ])
   
        NSLayoutConstraint.activate([
            descriptionLabel.widthAnchor.constraint(equalToConstant: self.frame.width/2)
        ])
        
        NSLayoutConstraint.activate([
            newsImageView.widthAnchor.constraint(equalToConstant: self.frame.width/2)
        ])

        NSLayoutConstraint.activate([
            newsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            newsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2),
            newsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            newsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2),
            newsStackView.heightAnchor.constraint(equalToConstant: 151)
        ])
    }
}
