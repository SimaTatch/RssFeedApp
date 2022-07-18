

import Foundation
import UIKit

class FeedParser: NSObject, XMLParserDelegate {
    
    private var rssItems: [RSSItem] = []
    private var currentElement = ""
    private var currentImageUrl = ""
    private var currentImageHeight = ""
    private var currentImageWidth = ""
    
    private var mainTitle = "" {
        didSet {
            mainTitle = mainTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentLink = "" {
        didSet {
            currentLink = currentLink.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentTitle = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentDescription = "" {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentPubDate = "" {
        didSet {
            currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
     private var parserCompletionHandler: (([RSSItem]) -> Void)?

    func parseFeed(url: String, completionHandler: (([RSSItem]) -> Void)?) {

        self.parserCompletionHandler = completionHandler
        let request = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            /// parse xml data
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        task.resume()
    }

    //MARK: - XML Parser Delegate

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        currentElement = elementName

        if currentElement == "item" {
            currentTitle = ""
            currentDescription = ""
            currentPubDate = ""
            currentImageUrl = ""
            currentLink = ""
        }

        if currentElement ==  "media:content" {
            if let url = attributeDict["url"] {
                currentImageUrl = ""
                currentImageUrl += url
            }
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        switch currentElement {
        case "title":
            if mainTitle == "" {
                mainTitle += string
            } else {
                currentTitle += string
            }
        case "link": currentLink += string
        case "description": currentDescription += string
        case "pubDate": currentPubDate += string
        default: break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "channel" {
            let rssItem = RSSItem(sourceName: mainTitle, title: currentTitle, description: currentDescription, pubDate: currentPubDate.toDate() ?? Date(), image: currentImageUrl, link: currentLink, isSaved: false)
            self.rssItems.append(rssItem)
        }
        
        if elementName == "item"{
            let rssItem = RSSItem(sourceName: mainTitle, title: currentTitle, description: currentDescription, pubDate: currentPubDate.toDate() ?? Date(), image: currentImageUrl, link: currentLink, isSaved: false)
            self.rssItems.append(rssItem)
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(rssItems)
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}
