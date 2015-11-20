//
//  DetailsViewController.swift
//  HelloWorld
//
//  Created by flybywind on 15/11/19.
//  Copyright © 2015年 flybywind. All rights reserved.
//

import UIKit
import MediaPlayer

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    // MARK: outlet
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tracksTable: UITableView!

    // MARK: properties
    var json: ITunesJson?
    var tracks = [Track]()
    var mediaPlayer = MPMoviePlayerController()
    var backgroundQueue: dispatch_queue_t?
    var tabedIdx : NSIndexPath?
    // 和SearchResultsViewController类似，这里也是为了防止循环依赖，因为viewcontroller需要api对象，
    // 但是，api对象的初始化又需要view controller作为其delegate传入。
//    lazy var api = APIControler(delegate: self)
    var api : APIControler!
    // MARK:  required
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    // MARK: override
    override func viewDidLoad() {
        super.viewDidLoad()
        if json != nil {
            api = APIControler(delegate: self)
            // Load in tracks
            api.lookupAlbum(self.json!.collectionId)
        } else {
            print("content is empty")
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
            let cell = tableView.dequeueReusableCellWithIdentifier("TrackCell") as! TrackCell
            let track = tracks[indexPath.row]
            cell.titleLabel.text = track.title
            cell.playIcon.text = "▶️"
            return cell
    }
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if (backgroundQueue == nil) {
            // 必须防止main queue里面，放在其他队列中没声音
            backgroundQueue = dispatch_get_main_queue()
        }
        dispatch_async(backgroundQueue!, {
            self.mediaPlayer.stop()
        })

        var curIndx : NSIndexPath?
        if (tabedIdx == nil || tabedIdx!.row != indexPath.row) {
            let track = tracks[indexPath.row]
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TrackCell {
                cell.playIcon.text = "🔳"
            }
            dispatch_async(backgroundQueue!, {
                self.mediaPlayer.contentURL = NSURL(string: track.previewUrl)
                self.mediaPlayer.play()
            })
            
            curIndx = indexPath
        }
        // reset other playing button
        if tabedIdx != nil {
            if let cell = tableView.cellForRowAtIndexPath(tabedIdx!) as? TrackCell {
                cell.playIcon.text = "▶️"
            }
        }
        tabedIdx = curIndx
    }
    func didReceiveData(ary: NSArray) {
        dispatch_async(dispatch_get_main_queue(), {
            self.tracks = Track.tracksWithJSON(ary)
            self.tracksTable.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
}
