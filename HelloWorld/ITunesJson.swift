//
//  ITunesJson.swift
//  HelloWorld
//
//  Created by flybywind on 15/11/19.
//  Copyright © 2015年 flybywind. All rights reserved.
//

import Foundation

struct ITunesJson {
    let title,
        description,
        price,
        thumbnailImageURL,
        largeImageURL,
        itemURL: String

    init(title:String, description:String, price:String,
        thumbnailImageUrl:String, largeImageUrl:String, itemUrl:String) {
        self.title = title
        self.description = description
        self.price = price
        self.thumbnailImageURL = thumbnailImageUrl
        self.largeImageURL = largeImageUrl
        self.itemURL = itemUrl 
    }
    static func iTunesWithJSON(results: NSArray) -> [ITunesJson] {
        // Create an empty array of Albums to append to from this list
        var json = [ITunesJson]()
        // Store the results in our table data array
        if results.count > 0 {
            // Sometimes iTunes returns a collection, not a track, so we check both for the 'name'
            for result in results {
                let name = result["trackCensoredName"] as? String ?? "default"
                // Sometimes price comes in as formattedPrice, sometimes as collectionPrice.. and sometimes it's a float instead of a string. Hooray!
                let price = result["formattedPrice"] as? String ?? "XXX"
                let description = result["description"] as? String ?? "default description"
                let thumbnailURL = result["artworkUrl60"] as? String ?? ""
                let imageURL = result["artworkUrl100"] as? String ?? ""
                let itemURL = result["collectionViewUrl"] as? String ?? ""
                
                json.append(ITunesJson(title: name, description: description, price: price, thumbnailImageUrl: thumbnailURL, largeImageUrl: imageURL, itemUrl: itemURL))
                
            }
        }
        return json
    }
}