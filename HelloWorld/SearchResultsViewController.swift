//
//  ViewController.swift
//  HelloWorld
//
//  Created by flybywind on 15/11/16.
//  Copyright © 2015年 flybywind. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {

    // MARK: outlet
    @IBOutlet var appsTableView : UITableView!
    
    // MARK: properties
    var tableData = []
    var api = APIControler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.    
        api.delegate = self
        api.searchItunesFor("image resize")
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
    
    // MARK: api delegate
    func didReceiveData(ary: NSArray) {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableData = ary
            self.appsTableView.reloadData()
        })
    }
    
}

