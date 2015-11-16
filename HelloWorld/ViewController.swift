//
//  ViewController.swift
//  HelloWorld
//
//  Created by flybywind on 15/11/16.
//  Copyright © 2015年 flybywind. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: table view delegate
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 相当于创建了一个cell，identifier为MyTestCell；
        // 和FoodTracker中在IB中创建cell prototype不同，那种cell要通过tableView.dequeueReusableCellWithIdentifier(_:forIndexPath:)获得，然后转化成我们需要的类型(as! MealTableViewCell)
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
            
        cell.textLabel?.text = "Row #\(indexPath.row)"
        cell.detailTextLabel?.text = "Subtitle #\(indexPath.row)"
        return cell
    }
}

