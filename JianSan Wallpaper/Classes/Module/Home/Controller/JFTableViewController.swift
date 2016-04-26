//
//  JFHomeTableViewController.swift
//  JianSan Wallpaper
//
//  Created by jianfeng on 16/2/4.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit
import YYWebImage
import SVProgressHUD
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()         // 准备UI
        setupRefreshView()  // 配置刷新控件
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
        loadingView.tintColor = UIColor(red:0.122,  green:0.729,  blue:0.949, alpha:1)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self!.pullDownRefresh()
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red:0.102,  green:0.102,  blue:0.102, alpha:1))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }
    
    /**
     下拉刷新
     */
    func pullDownRefresh() -> Void {
        array.removeAll()
        currentPage = 1
        updateData(JFLoadMethod.pullDown, category: currentCategoryModel!.category!, currentPage: currentPage)
    }
    
    /**
     上拉加载更多
     */
    func pullUpLoadMore() -> Void {
        currentPage += 1
        updateData(JFLoadMethod.pullUp, category: currentCategoryModel!.category!, currentPage: currentPage)
    }
    
    /**
     加载数据
     */
    private func updateData(loadMethod: JFLoadMethod, category: String, currentPage: Int, onePageCount: Int = 10) {
        
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
                    SVProgressHUD.showInfoWithStatus("没有更多数据")
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
                SVProgressHUD.showInfoWithStatus("您的网络不给力")
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
        
        // 进度圈半径
        let radius: CGFloat = 30.0
        let progressView = JFProgressView(frame: CGRect(x: SCREEN_WIDTH / 2 - radius, y: 250 / 2 - radius, width: radius * 2, height: radius * 2))
        progressView.radius = radius
        progressView.backgroundColor = UIColor.whiteColor()
        
        cell.imageView?.yy_setImageWithURL(NSURL(string: "\(baseURL)\(array[indexPath.row].path!)"), placeholder: UIImage(named: "temp_image"), options: YYWebImageOptions.SetImageWithFadeAnimation, progress: { (receivedSize, expectedSize) in
            
            cell.contentView.addSubview(progressView)
            progressView.progress = CGFloat(receivedSize) / CGFloat(expectedSize)
            
            }, transform: { (image, url) -> UIImage? in
                return image
            }, completion: { (image, url, type, stage, error) in
                progressView.removeFromSuperview()
        })
        
        // 如果菊花正在显示,就表示正在加载数据,就不加载数据
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
        detailVc.image = (tableView.cellForRowAtIndexPath(indexPath) as? JFTableViewCell)?.imageView?.image
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
        indicator.color = UIColor.magentaColor()
        return indicator
    }()
    
}
