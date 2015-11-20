//
//  APIController.swift
//  HelloWorld
//
//  Created by flybywind on 15/11/18.
//  Copyright © 2015年 flybywind. All rights reserved.
//

import Foundation

protocol APIControllerProtocol {
    func didReceiveData(ary:NSArray)
}

class APIControler {
    var delegate : APIControllerProtocol
    
    init(delegate: APIControllerProtocol) {
        self.delegate = delegate
    }
    // MARK: methods
    func get(url:String) {
        let url = NSURL(string: url)
        let session = NSURLSession.sharedSession()
        let task =
        session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            print("Task completed")
            if (error != nil)  {
                // If there is an error in the web request, print it to the console
                print(error!.localizedDescription)
            }
            let ret: AnyObject?
            do {
                ret = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                if let jsonResult = ret as? NSDictionary {
                    // swift不支持多线程，原来是直接用框架的
                    if let results = jsonResult["results"] as? NSArray {
                        self.delegate.didReceiveData(results)
                        //                          print("json results:", results)
                    }
                }
            } catch let err as NSError {
                print("JSON Error \(err.localizedDescription)")
            }
            
        })
        
        // The task is just an object with all these properties set
        // In order to actually make the web request, we need to "resume"
        task.resume()
    }
    func searchItunesFor(searchTerm: String) {
        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        // 当你import框架的时候，框架已经对重要类型进行了映射，比如NSString到String，所以NSString的所有方法，swift的String都可以用
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        // Now escape anything else that isn't URL-friendly
        if let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()){
            let urlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=music&entity=album"

            get(urlPath)
        }
    }
}