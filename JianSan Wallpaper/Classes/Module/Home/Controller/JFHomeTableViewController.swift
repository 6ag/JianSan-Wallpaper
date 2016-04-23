//
//  JFHomeTableViewController.swift
//  JianSan Wallpaper
//
//  Created by jianfeng on 16/2/4.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit
import YYWebImage
import MJRefresh

class JFHomeTableViewController: UITableViewController, JFCategoriesMenuViewDelegate {
    
    let identifier = "homeCell"
    
    var array: [String]?
    
    /// 当前分类
    var currentItem: JFCategoryModel? {
        didSet {
//            tableView.mj_header.beginRefreshing()
            updateData()
        }
    }
    
    // 写死的数据
    let itemIcons = ["category_icon_tc", "category_icon_cy", "category_icon_wh", "category_icon_cj", "category_icon_tm", "category_icon_qx", "category_icon_sl", "category_icon_wd", "category_icon_mj", "category_icon_gb", "category_icon_cyun", "category_icon_cg"]
    let itemTitles = ["天策", "纯阳", "万花", "藏剑", "唐门", "七秀", "少林", "五毒", "明教", "丐帮", "苍云", "长歌"]
    let itemUrls = [tc_category, cy_category, wh_category, cj_category, tm_category, qx_category, sl_category, wd_category, mj_category, gb_category, cyun_category, cg_category]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigation_category")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(didTappedLeftMenuItem))
        
        tableView.backgroundColor = UIColor(red:0.063,  green:0.063,  blue:0.063, alpha:1)
        tableView.rowHeight = 250;
        tableView.registerClass(JFHomeCell.self, forCellReuseIdentifier: identifier)
        
//        tableView.mj_header = MJRefreshHeader(refreshingTarget: self, refreshingAction: #selector(JFHomeTableViewController.updateData))
        currentItem = JFCategoryModel(dict: ["iconName" : itemIcons[0], "title" : itemTitles[0], "url" : itemUrls[0]])
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
    }
    
    /**
     左上角按钮事件
     */
    @objc private func didTappedLeftMenuItem() {
        
        // 转模型
        var items: [JFCategoryModel] = []
        for index in 0..<itemIcons.count {
            let item = JFCategoryModel(dict: ["iconName" : itemIcons[index], "title" : itemTitles[index], "url" : itemUrls[index]])
            items.append(item)
        }
        
        // 创建分类视图、并显示
        let categoriesMenuView = JFCategoriesMenuView(items: items)
        categoriesMenuView.delegate = self
        categoriesMenuView.show()
    }
    
    // MARK: - JFCategoriesMenuViewDelegate
    func didTappedItem(item: JFCategoryModel) {
        currentItem = item
    }
    
    /**
     加载数据
     */
    @objc private func updateData() {
        JFNetworkTools.shareNetworkTools.get(currentItem!.url!) { (success, result, error) -> () in
            if success {
                self.array = result
                self.title = "\(self.currentItem!.title!) \(result!.count) 张"
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
        cell.layer.borderColor = UIColor(red:0.063,  green:0.063,  blue:0.063, alpha:1).CGColor
        cell.layer.borderWidth = 5
        print("\(imageURL)\(array![indexPath.row]).png")
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        var rotation = CATransform3DMakeTranslation(0, 50, 20)
        rotation.m34 = 1.0 / -600
        
        cell.layer.shadowColor = UIColor(red:0.063,  green:0.063,  blue:0.063, alpha:1).CGColor
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
        let detailVc = JFDetailViewController()
        detailVc.image = (tableView.cellForRowAtIndexPath(indexPath) as? JFHomeCell)?.imageView?.image
        presentViewController(detailVc, animated: true, completion: nil)
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let array = tableView.visibleCells
        for cell in array {
            (cell as! JFHomeCell).cellOffset()
        }
    }
    
}
