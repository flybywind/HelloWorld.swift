//
//  DetailsViewController.swift
//  HelloWorld
//
//  Created by flybywind on 15/11/19.
//  Copyright © 2015年 flybywind. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: outlet
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tracksTable: UITableView!
    
    // MARK: properties
    var json: ITunesJson?
    var tracks = [Track]()
    // 和SearchResultsViewController类似，这里也是为了防止循环依赖，因为viewcontroller需要api对象，
    // 但是，api对象的初始化又需要view controller作为其delegate传入。
    lazy var api = APIControler(delegate: self)

    // MARK:  required
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    // MARK: override
    override func viewDidLoad() {
        super.viewDidLoad()
        if json != nil {
            // Load in tracks
            api.lookupAlbum(self.json!.collectionId)
        }
        titleLabel.text = json?.title
        if let imagUrl = json?.largeImageURL {
            dispatch_async(dispatch_get_main_queue(), {
                if let data = NSData(contentsOfURL: NSURL(string:imagUrl)!) {
//                    print("get large image url:", imagUrl)
                    self.coverImage.image = UIImage(data: data)
                } else {
                    print("get image failed!")
                }
            })
        }
    }
    // MARK: protocol
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func didReceiveAPIResults(results: NSArray) {
        dispatch_async(dispatch_get_main_queue(), {
            self.tracks = ITunesJson.tracksWithJSON(results)
            self.tracksTable.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
}
