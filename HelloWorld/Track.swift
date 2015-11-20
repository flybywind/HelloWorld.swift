//
//  Track.swift
//  HelloWorld
//
//  Created by flybywind on 15/11/20.
//  Copyright © 2015年 flybywind. All rights reserved.
//

import Foundation
struct Track {
    let title: String
    let price: String
    let previewUrl: String
    
    init(title: String, price: String, previewUrl: String) {
        self.title = title
        self.price = price
        self.previewUrl = previewUrl
    }
}