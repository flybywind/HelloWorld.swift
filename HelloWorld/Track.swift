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
    let price: Float64
    let previewUrl: String
    
    init(title: String, price: Float64, previewUrl: String) {
        self.title = title
        self.price = price
        self.previewUrl = previewUrl
    }
    static func tracksWithJSON(results: NSArray) -> [Track] {
        var tracks = [Track]()
        for trackInfo in results {
            // Create the track
            if let kind = trackInfo["kind"] as? String {
                if kind=="song" {
                    var trackPrice = trackInfo["trackPrice"] as? Float64
                    var trackTitle = trackInfo["trackName"] as? String
                    var trackPreviewUrl = trackInfo["previewUrl"] as? String
                    if(trackTitle == nil) {
                        print("no trackName in \(trackInfo)")
                        trackTitle = "Unknown"
                    }
                    if(trackPrice == nil) {
                        print("No trackPrice in \(trackInfo)")
                        trackPrice = 0
                    }
                    if(trackPreviewUrl == nil) {
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