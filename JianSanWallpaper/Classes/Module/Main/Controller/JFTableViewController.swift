//
//  JFHomeTableViewController.swift
//  JianSan Wallpaper
//
//  Created by jianfeng on 16/2/4.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

enum JFLoadMethod {
    case pullUp
    case pullDown
}

class JFTableViewController: UITableViewController {
    
    let identifier = "homeCell"
    
    var array: [JFWallPaperModel] = []
    
    /// 页码默认为1
    var currentPage = 1
    
    /// 当前分类
    var currentCategoryModel: JFCategoryModel? {
        didSet {
            // 只有第一次才默认加载
            if currentPage == 1 {
                pullDownRefresh()
            }
        }
    }
    
    /// 是否是收藏控制器
    var isStarVc = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()         // 准备UI
        setupRefreshView()  // 配置刷新控件
        
        if isStarVc {
            pullDownRefresh()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
    }
    
    /**
     准备视图
     */
    func prepareUI() -> Void {
        
        // tableView
        tableView.tableFooterView = pullUpView
        tableView.backgroundColor = UIColor(red:0.063,  green:0.063,  blue:0.063, alpha:1)
        tableView.rowHeight = 250;
        tableView.registerClass(JFTableViewCell.self, forCellReuseIdentifier: identifier)
    }
    
    /**
     配置刷新控件
     */
    func setupRefreshView() -> Void {
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red:0.122,  green:0.729,  blue:0.949, alpha:0.8)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self!.pullDownRefresh()
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(NAVBAR_TINT_COLOR)
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }
    
    /**
     下拉刷新
     */
    func pullDownRefresh() -> Void {
        array.removeAll()
        currentPage = 1
        if isStarVc {
            updateDataFromLocation(JFLoadMethod.pullDown, currentPage: currentPage)
        } else {
            updateDataFromNetwork(JFLoadMethod.pullDown, category: currentCategoryModel!.category!, currentPage: currentPage)
        }
        
    }
    
    /**
     上拉加载更多
     */
    func pullUpLoadMore() -> Void {
        currentPage += 1
        if isStarVc {
            updateDataFromLocation(JFLoadMethod.pullUp, currentPage: currentPage)
        } else {
           updateDataFromNetwork(JFLoadMethod.pullUp, category: currentCategoryModel!.category!, currentPage: currentPage)
        }
    }
    
    /**
     从本地加载数据
     
     - parameter loadMethod:   加载方式
     - parameter currentPage:  当前页
     - parameter onePageCount: 每页数量
     */
    private func updateDataFromLocation(loadMethod: JFLoadMethod, currentPage: Int, onePageCount: Int = 10) {
        
        JFFMDBManager.sharedManager.getStarWallpaper(currentPage, onePageCount: onePageCount) { (result) in
            
            self.pullUpView.stopAnimating()
            
            if result != nil || result?.count != 0 {
                let minId = self.array.last?.id ?? 0
                let maxId = self.array.first?.id ?? 0
                
                if result == nil || result?.count == 0 {
                    JFProgressHUD.showInfoWithStatus("没有更多数据")
                    return
                }
                
                // 返回的id是逆序的，所以拼接需要反转
                if loadMethod == JFLoadMethod.pullDown  { // 加载最新
                    for dict in result!.reverse() {
                        let wallPaperModel = JFWallPaperModel(dict: dict)
                        if wallPaperModel.id > maxId {
                            self.array.insert(wallPaperModel, atIndex: 0)
                        }
                    }
                } else {
                    for dict in result! {
                        let wallPaperModel = JFWallPaperModel(dict: dict)
                        if wallPaperModel.id < minId {
                            self.array.append(wallPaperModel)
                        }
                    }
                }
                
                self.tableView.reloadData()
            } else {
                JFProgressHUD.showInfoWithStatus("没有更多数据")
            }
            
        }
        
    }
    
    /**
     从网络加载数据
     
     - parameter loadMethod:   加载方式
     - parameter category:     分类
     - parameter currentPage:  当前页
     - parameter onePageCount: 每页数量
     */
    private func updateDataFromNetwork(loadMethod: JFLoadMethod, category: String, currentPage: Int, onePageCount: Int = 10) {
        
        let parameters = [
            "category" : category,
            "currentPage" : currentPage,
            "onePageCount" : onePageCount
        ]
        
        JFNetworkTools.shareNetworkTools.get(getWallpaper, parameters: parameters as! [String : AnyObject]) { (success, result, error) -> () in
            
            // 停止菊花
            self.pullUpView.stopAnimating()
            
            if success {
                
                let minId = self.array.last?.id ?? 0
                let maxId = self.array.first?.id ?? 0
                
                if result == nil || result?.count == 0 {
                    JFProgressHUD.showInfoWithStatus("没有更多数据")
                    return
                }
                
                // 返回的id是逆序的，所以拼接需要反转
                if loadMethod == JFLoadMethod.pullDown  { // 加载最新
                    for dict in result!.reverse() {
                        let wallPaperModel = JFWallPaperModel(dict: dict)
                        if wallPaperModel.id > maxId {
                            self.array.insert(wallPaperModel, atIndex: 0)
                        }
                    }
                } else {
                    for dict in result! {
                        let wallPaperModel = JFWallPaperModel(dict: dict)
                        if wallPaperModel.id < minId {
                            self.array.append(wallPaperModel)
                        }
                    }
                }
                
                self.tableView.reloadData()
            } else {
                JFProgressHUD.showInfoWithStatus("您的网络不给力")
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! JFTableViewCell
        cell.wallPaperModel = array[indexPath.row]
        
        // 正在加载数据 就不加载数据
        if indexPath.row == array.count - 1 && !pullUpView.isAnimating() {
            // 菊花转起来
            pullUpView.startAnimating()
            
            // 上拉加载更多数据
            pullUpLoadMore()
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailVc = JFDetailViewController()
        detailVc.image = (tableView.cellForRowAtIndexPath(indexPath) as? JFTableViewCell)?.wallPaperImageView.image
        detailVc.path = array[indexPath.row].path
        presentViewController(detailVc, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! JFTableViewCell).cellOffset()
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let array = tableView.visibleCells
        for cell in array {
            // 里面的图片跟随移动
            (cell as! JFTableViewCell).cellOffset()
        }
        
    }
    
    deinit {
        tableView.dg_removePullToRefresh()
    }
    
    /// 上拉加载更多数据显示的菊花
    private lazy var pullUpView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        indicator.color = UIColor.darkGrayColor()
        return indicator
    }()
    
}
