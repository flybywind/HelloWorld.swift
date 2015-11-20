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
        price,
        thumbnailImageURL,
        largeImageURL,
        artistURL,
        itemURL: String
    let collectionId: Int
    
    init(title:String, id:Int, price:String,
        thumbnailImageUrl:String, largeImageUrl:String, itemUrl:String, artistUrl:String) {
        self.title = title
        self.price = price
        self.thumbnailImageURL = thumbnailImageUrl
        self.largeImageURL = largeImageUrl
        self.itemURL = itemUrl
        self.artistURL = artistUrl
        self.collectionId = id
    }
    static func iTunesWithJSON(results: NSArray) -> [ITunesJson] {
        // Create an empty array of Albums to append to from this list
        var json = [ITunesJson]()
        // Store the results in our table data array
        if results.count > 0 {
            // Sometimes iTunes returns a collection, not a track, so we check both for the 'name'
            for result in results {
                var name = result["trackName"] as? String
                if name == nil {
                    name = result["collectionName"] as? String ?? "no name"
                }
                
                // Sometimes price comes in as formattedPrice, sometimes as collectionPrice.. and sometimes it's a float instead of a string. Hooray!
                var price = result["formattedPrice"] as? String
                if price == nil {
                    price = result["collectionPrice"] as? String
                    if price == nil {
                        let priceFloat = result["collectionPrice"] as? Float
                        let nf = NSNumberFormatter()
                        nf.maximumFractionDigits = 2
                        if priceFloat != nil {
                            price = "$\(nf.stringFromNumber(priceFloat!)!)"
                        }
                    }
                }
                
                let thumbnailURL = result["artworkUrl60"] as? String ?? ""
                let imageURL = result["artworkUrl100"] as? String ?? ""
                let artistURL = result["artistViewUrl"] as? String ?? ""
                
                var itemURL = result["collectionViewUrl"] as? String
                if itemURL == nil {
                    itemURL = result["trackViewUrl"] as? String ?? ""
                }

                if let collectionId = result["collectionId"] as? Int {
                    json.append(ITunesJson(title: name!, id: collectionId, price: price!, thumbnailImageUrl: thumbnailURL, largeImageUrl: imageURL, itemUrl: itemURL!, artistUrl: artistURL))
                } else {
                    print("can't find collection id")
                }
            }
        }
        return json
    }
    static func tracksWithJSON(results: NSArray) -> [Track] {
        var tracks = [Track]()
        for trackInfo in results {
            // Create the track
            if let kind = trackInfo["kind"] as? String {
                if kind=="song" {
                    var trackPrice = trackInfo["trackPrice"] as? String
                    var trackTitle = trackInfo["trackName"] as? String
                    var trackPreviewUrl = trackInfo["previewUrl"] as? String
                    if(trackTitle == nil) {
                        trackTitle = "Unknown"
                    }
                    else if(trackPrice == nil) {
                        print("No trackPrice in \(trackInfo)")
                        trackPrice = "?"
                    }
                    else if(trackPreviewUrl == nil) {
                        trackPreviewUrl = ""
                    }
                    let track = Track(title: trackTitle!, price: trackPrice!, previewUrl: trackPreviewUrl!)
                    tracks.append(track)
                }
            }
        }
        return tracks
    }
}