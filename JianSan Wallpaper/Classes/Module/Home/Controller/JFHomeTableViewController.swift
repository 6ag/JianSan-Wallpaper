//
//  JFHomeTableViewController.swift
//  JianSan Wallpaper
//
//  Created by jianfeng on 16/2/4.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit
import YYWebImage

class JFHomeTableViewController: UITableViewController {
    
    let identifier = "homeCell"
    
    var array: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "天策 共28张"
        loadData(tc_category)
        
        tableView.backgroundColor = UIColor.blackColor()
        tableView.rowHeight = 250;
        tableView.registerClass(JFHomeCell.self, forCellReuseIdentifier: identifier)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarHidden = false
    }
    
    private func loadData(url: String) {
        JFNetworkTools.shareNetworkTools.get(url) { (success, result, error) -> () in
            if success {
                self.array = result
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! JFHomeCell
        cell.layer.borderColor = UIColor.blackColor().CGColor
        cell.layer.borderWidth = 5
        cell.imageView?.yy_setImageWithURL(NSURL(string: "\(imageURL)\(array![indexPath.row]).png"), placeholder: UIImage(named: "temp_image"))
        print("\(imageURL)\(array![indexPath.row]).png")
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        var rotation = CATransform3DMakeTranslation(0, 50, 20)
        rotation = CATransform3DScale(rotation, 0.9, 0.9, 1)
        rotation.m34 = 1.0 / -600
        
        cell.layer.shadowColor = UIColor.blackColor().CGColor
        cell.layer.shadowOffset = CGSize(width: 10, height: 10)
        cell.alpha = 0
        cell.layer.transform = rotation
        
        UIView.animateWithDuration(0.6) { () -> Void in
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1
            cell.layer.shadowOffset = CGSizeMake(0, 0)
        }
        
        (cell as! JFHomeCell).cellOffset()
        cell.imageView?.yy_setImageWithURL(NSURL(string: "\(imageURL)\(array![indexPath.row]).png"), placeholder: UIImage(named: "temp_image"))
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("xxxxxx")
        let detailVc = JFDetailViewController()
        detailVc.image = (tableView.cellForRowAtIndexPath(indexPath) as? JFHomeCell)?.imageView?.image
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.presentViewController(detailVc, animated: true, completion: nil)
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let array = tableView.visibleCells
        for cell in array {
            (cell as! JFHomeCell).cellOffset()
        }
    }
    
}
