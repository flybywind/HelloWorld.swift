//
//  ViewController.swift
//  HelloWorld
//
//  Created by flybywind on 15/11/16.
//  Copyright © 2015年 flybywind. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: outlet
    @IBOutlet var appsTableView : UITableView!
    
    // MARK: properties
    var tableData = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchItunesFor("image resize")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: table view delegate
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 相当于创建了一个cell，identifier为MyTestCell；
        // 和FoodTracker中在IB中创建cell prototype不同，那种cell要通过tableView.dequeueReusableCellWithIdentifier(_:forIndexPath:)获得，然后转化成我们需要的类型(as! MealTableViewCell)
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        
        if let rowData = tableData[indexPath.row] as? NSDictionary,
            urlString = rowData["artworkUrl60"] as? String,
            // Create an NSURL instance from the String URL we get from the API
            imgURL = NSURL(string: urlString),
            // Download an NSData representation of the image at the URL
            imgData = NSData(contentsOfURL: imgURL),
            // Get the formatted price string for display in the subtitle
            formattedPrice = rowData["formattedPrice"] as? String,
            // Get the track name
            description = rowData["description"] as? String {
                // Get the formatted price string for display in the subtitle
                cell.detailTextLabel?.text = formattedPrice
                // Update the imageView cell to use the downloaded image data
                cell.imageView?.image = UIImage(data: imgData)
                // Update the textLabel text to use the trackName from the API
                // 系统会默认做这种事情，此处就是练习
                var text : String
                if description.characters.count > 30 {
                    text = description.substringToIndex(description.startIndex.advancedBy(30)) + "..."
                } else {
                    text = description
                }
                cell.textLabel?.text = text
                print("description:", text)
        }
        return cell
    }
    
    // MARK: methods
    func searchItunesFor(searchTerm: String) {
        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        // 当你import框架的时候，框架已经对重要类型进行了映射，比如NSString到String，所以NSString的所有方法，swift的String都可以用
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        // Now escape anything else that isn't URL-friendly
        if let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()){
            let urlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
            let url = NSURL(string: urlPath)
            let session = NSURLSession.sharedSession()
            let task =
            session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
                print("Task completed")
                if (error != nil)  {
                    // If there is an error in the web request, print it to the console
                    print(error!.localizedDescription)
                }
                let ret: AnyObject?
                do {
                    ret = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                    if let jsonResult = ret as? NSDictionary {
                        // swift不支持多线程，原来是直接用框架的
                        if let results = jsonResult["results"] as? NSArray {
//                            print("json results:", results)
                            dispatch_async(dispatch_get_main_queue(), {
                                self.tableData = results
                                self.appsTableView.reloadData()
                            })
                        }
                    }
                } catch let err as NSError {
                    print("JSON Error \(err.localizedDescription)")
                }
                
            })
            
            // The task is just an object with all these properties set
            // In order to actually make the web request, we need to "resume"
            task.resume()
        }
    }
}

