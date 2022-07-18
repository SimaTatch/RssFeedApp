
import XCTest
import CoreData
@testable import NewsApp

class NewsAppTests: XCTestCase {
    
    var coreManager: CoreDataManager!
    var rssItemsArray = [RSSItem]()
    let urlStringNYT = "https://rss.nytimes.com/services/xml/rss/nyt/World.xml"

    override func setUp() {
        super.setUp()
        coreManager = CoreDataManager()
    }

    func test_create_newsItem() {
        let rssItem1 = RSSItem(sourceName: "NYT", title: "SomeTitle", description: "SomeDescription", pubDate: Date(), image: "SomeUrl", link: "SomeLink", isSaved: true)
        let rssItem2 = RSSItem(sourceName: "NYT2", title: "SomeTitle2", description: "SomeDescription2", pubDate: Date(), image: "SomeUrl2", link: "SomeLink2", isSaved: false)
        rssItemsArray.append(rssItem1)
        rssItemsArray.append(rssItem2)
        coreManager.saveDataOf(newsRSSArray: rssItemsArray)
        let newsItem = coreManager.getCertainItemFromCoreData(with: "SomeTitle2")

        XCTAssertEqual("SomeTitle2", newsItem!.title)

    }

    func test_update_newsItem() {
        let rssItem1 = RSSItem(sourceName: "NYT", title: "SomeTitle", description: "SomeDescription", pubDate: Date(), image: "SomeUrl", link: "SomeLink", isSaved: true)
        rssItemsArray.append(rssItem1)
        coreManager.saveDataOf(newsRSSArray: rssItemsArray)
        coreManager.updateItemNEWS(itemToUpdate: "SomeTitle", isSavedUpdated: false)
        let newsItem = coreManager.getCertainItemFromCoreData(with: "SomeTitle")

        XCTAssertEqual(false, newsItem!.isSaved)
    }

    func test_delete_newsItem() {
        let rssItem1 = RSSItem(sourceName: "NYT", title: "SomeTitle", description: "SomeDescription", pubDate: Date(), image: "SomeUrl", link: "SomeLink", isSaved: true)
        rssItemsArray.append(rssItem1)
        coreManager.saveDataOf(newsRSSArray: rssItemsArray)
        coreManager.deleteObjectsFromCoreData(context: coreManager.context)
        let newsItem = coreManager.getCertainItemFromCoreData(with: "SomeTitle")

        XCTAssertNotEqual ("SomeTitle", newsItem?.title)
    }

    func test_xml_parser() {
        let feedParser = FeedParser()
        feedParser.parseFeed(url: urlStringNYT) { (rssItems) in
            XCTAssertNotNil(rssItems)
        }
    }
    
}
