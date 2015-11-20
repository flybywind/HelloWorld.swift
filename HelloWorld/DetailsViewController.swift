//
//  DetailsViewController.swift
//  HelloWorld
//
//  Created by flybywind on 15/11/19.
//  Copyright © 2015年 flybywind. All rights reserved.
//

import UIKit

import UIKit

class DetailsViewController: UIViewController {
    // MARK: outlet
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var json: ITunesJson?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
}
