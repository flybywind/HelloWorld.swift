//
//  ViewController.swift
//  HelloWorld
//
//  Created by flybywind on 15/11/16.
//  Copyright © 2015年 flybywind. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController,
    UITableViewDataSource,
    UITableViewDelegate,
    APIControllerProtocol {

    // MARK: outlet
    @IBOutlet var appsTableView : UITableView!
    
    // MARK: properties
    var tableData = [ITunesJson]()
//    var api: APIControler!
    var api:APIControler!
    var imageCache = [String:UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.   
        api = APIControler(delegate: self)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api.searchItunesFor("Bob Dylan")
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
        // 相当于创建了一个cell，identifier为MyTestCell；每次scroll都有要创建一个新cell，效率低而且浪费内存！
        //        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        // 这种方式更快更省
        let kCellIdentifier = "SearchResultCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier)!
        let json = self.tableData[indexPath.row]
        // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
        
        // Get the formatted price string for display in the subtitle
        cell.detailTextLabel?.text = json.price
        // Update the textLabel text to use the trackName from the API
        cell.textLabel?.text = json.title
        
        // Start by setting the cell's image to a static file
        // Without this, we will end up without an image view!
        cell.imageView?.image = UIImage(named: "Blank")
        print("image url:", json.thumbnailImageURL)
        // If this image is already cached, don't re-download
        if let img = imageCache[json.thumbnailImageURL] {
            cell.imageView?.image = img
        }
        else {
            let imgURL = NSURL(string: json.thumbnailImageURL)!
            // The image isn't cached, download the img data
            // We should perform this in a background thread
            let mainQueue = NSOperationQueue.mainQueue()
            let session = NSURLSession(configuration:
                NSURLSessionConfiguration.defaultSessionConfiguration(),
                delegate: nil, delegateQueue: mainQueue)
            let task =
            session.dataTaskWithURL(imgURL, completionHandler: { (data, response, error) -> Void in
                if error == nil {
                    print("image task done")
                    if let resp = response as? NSHTTPURLResponse {
                        print("got image url:", resp.URL)
                    }
                    // Convert the downloaded data in to a UIImage object
                    let image = UIImage(data: data!)
                    // Store the image in to our cache
                    self.imageCache[json.thumbnailImageURL] = image
                    // Update the cell
                    // 已经是mainQueue，不需要dispatch到main queue了。
                    //                            dispatch_async(dispatch_get_main_queue(), {
                    //  The reason we use this is because sometime’s the cell that this code was running for may no longer be visible, and will have been re-used. So, to avoid setting an image on an unintended cell, we retrieve the cell from the tableView, based on the index path. If this comes back nil, then we know the cell is no longer visible and can skip the update.
                    // 而且，ui的更新必须在主线程中进行，所以必须提交到这里面
                    if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                        cellToUpdate.imageView?.image = image
                    }
                    //                            })
                }
                else {
                    print("Error: \(error!.localizedDescription)")
                }
            })
            task.resume()
        }
        
        
        return cell
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        // Get the row data for the selected row
//        if let rowData = self.tableData[indexPath.row] as? NSDictionary,
//            // Get the name of the track for this row
//            description = rowData["description"] as? String,
//            // Get the price of the track on this row
//            formattedPrice = rowData["formattedPrice"] as? String {
//                let name =  description.substringToIndex(description.startIndex.advancedBy(20)) + " | " + formattedPrice
//                let alert = UIAlertController(title: name, message: description, preferredStyle: .Alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
//                self.presentViewController(alert, animated: true, completion: nil)
//        }
//    }
    // MARK: segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailView = segue.destinationViewController as? DetailsViewController {
            let indx = appsTableView!.indexPathForSelectedRow!.row
            let selected = tableData[indx]
            detailView.json = selected
        }
    }
    // MARK: api delegate
    func didReceiveData(ary: NSArray) {
        // 必须放到独立线程中，否则报错
        // This application is modifying the autolayout engine from a background thread, which can lead to engine corruption and weird crashes.  This will cause an exception in a future release
        dispatch_async(dispatch_get_main_queue(), {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.tableData = ITunesJson.iTunesWithJSON(ary)
            self.appsTableView!.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
}

