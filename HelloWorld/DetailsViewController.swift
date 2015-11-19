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
    
    @IBOutlet weak var descriptText: UITextView!
    var json: ITunesJson?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = json?.title
        descriptText.text = json?.description
        if let imagUrl = json?.largeImageURL {
            if let data = NSData(contentsOfFile: imagUrl) {
                print("get large image url:", json?.largeImageURL)
                coverImage.image = UIImage(data: data)
            }
        }
//        coverImage.image = UIImage(data: NSData(contentsOfFile: (json?.largeImageURL)!)!)
    }
}
