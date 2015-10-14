//
//  Home.swift
//  smartmixer
//
//  Created by 姚俊光 on 14/9/30.
//  Copyright (c) 2014年 smarthito. All rights reserved.
//

import UIKit

//该变量用于判断是不是需要重新加载数据
var needRefresh:Bool=false

@available(iOS 8.0, *)
class Home: UIViewController ,UIScrollViewDelegate ,HomeDirectionSyncDelegate {
    
    
    @IBOutlet var mainScroll:UIScrollView!
    
    //@MARK:图片控件的对象
    @IBOutlet var sence0:UIImageView!
    @IBOutlet var sence1:UIImageView!
    @IBOutlet var sence2:UIImageView!
    @IBOutlet var sence3:UIImageView!
    @IBOutlet var sence4:UIImageView!
    @IBOutlet var sence5:UIImageView!
    @IBOutlet var sence6:UIImageView!
    @IBOutlet var sence7:UIImageView!
    @IBOutlet var sence8:UIImageView!
    @IBOutlet var sence9:UIImageView!
    
    
    @IBOutlet var senceBar:UIImageView!
    
    @IBOutlet var senceMusic:UIImageView!
    
    //@MARK:按钮的对象
    @IBOutlet var button0:UIButton!
    @IBOutlet var button1:UIButton!
    @IBOutlet var button2:UIButton!
    @IBOutlet var button3:UIButton!
    @IBOutlet var button4:UIButton!
    @IBOutlet var button5:UIButton!

    var JsonData:NSArray!
    
    var refreshControl = UIRefreshControl()
    
    class func HomeRoot()->UIViewController{
        // instantiateInitialViewController 初始控制器
        var home = UIStoryboard(name: "Home"+deviceDefine, bundle: nil).instantiateInitialViewController()
        return home!
    }
    
    //@MARK:图像的加载处理
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        // 根据按所在界面的navigationbar与tabbar的高度，自动调整scrollview的 inset
        self.automaticallyAdjustsScrollViewInsets = false
        //添加刷新
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "烘焙进行中")
        self.mainScroll.addSubview(refreshControl)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        rootController.showOrhideToolbar(true)
        if(needRefresh){
            loadData()
            needRefresh=false
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if(mainScroll != nil){
            mainScroll.contentSize = CGSize(width: 320, height: 1000)
            self.view.layoutIfNeeded()
        }
    }
    
    //@MARK: 刷新数据
    func refreshData() {
        refreshControl.attributedTitle = NSAttributedString(string: "正在更新")
        var homeDirectionSync = HomeDirectionSync()
        homeDirectionSync.byForce = true
        homeDirectionSync.delegate = self
        //去翻滚吧，蛋炒饭
        homeDirectionSync.UpdateHomeSync()
    }
    
    //数据刷星的回调
    func homeDirectionSync(sender:HomeDirectionSync,NeedRefresh refresh:Bool){
        self.refreshControl.endRefreshing()
        if(refresh){
            loadData()
        }
    }
    
    //加载与显示数据
    func loadData(){
        let fileManager = NSFileManager.defaultManager()
        var path:NSURL!=nil
        //去更新吧少年
        let homeDirectionSync = HomeDirectionSync()
        let remote = fileManager.isReadableFileAtPath(applicationDocumentsPath+"/homedirections/latest.json")
        if(remote){
            path = NSURL(fileURLWithPath:applicationDocumentsPath+"/homedirections/latest.json")
        }else{ //先加载老的
            homeDirectionSync.byForce = true
            path = NSBundle.mainBundle().URLForResource("HomeDirections", withExtension: "json")
        }
        var jsonData : NSData!
        do{
            jsonData = try NSData(contentsOfURL: path, options: .DataReadingMappedIfSafe)
        }catch{
            
        }
        var rootDescription : NSDictionary!
        do{
            rootDescription = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
        }catch{
            
        }
        JsonData = rootDescription["data"] as! NSArray
        
        //翻滚吧，蛋炒饭
        homeDirectionSync.UpdateHomeSync()
        
        for index in 0...9 {
            var item:NSDictionary = JsonData[index] as! NSDictionary
            var sence = self.valueForKey("sence\(index)") as! UIImageView!
            if(remote){
                sence.image = UIImage(contentsOfFile: applicationDocumentsPath+"/homedirections/"+(item["image"] as! String))
            }else{
                sence.image = UIImage(named: (item["image"] as! String))
            }
            var tapGuesture = UITapGestureRecognizer()
            tapGuesture.addTarget(self, action: "OnClickImageSence:")
            sence.tag = index
            // 默认是false，为了响应tap事件
            sence.userInteractionEnabled = true
            sence.addGestureRecognizer(tapGuesture)
        }
        
        var tapGuesture = UITapGestureRecognizer()
        tapGuesture.addTarget(self, action: "OnClickMyBar:")
        senceBar.userInteractionEnabled = true
        senceBar.addGestureRecognizer(tapGuesture)
        
        var tapGuesture2 = UITapGestureRecognizer()
        tapGuesture2.addTarget(self, action: "OnClickMusic:")
        senceMusic.userInteractionEnabled = true
        senceMusic.addGestureRecognizer(tapGuesture2)
        
        for index in 0...5 {
            var item:NSDictionary = JsonData[10+index] as! NSDictionary
            var button = self.valueForKey("button\(index)") as! UIButton!
            button.setTitle("#"+(item["title"] as! String)+"#", forState: UIControlState.Normal)
        }
    }
    //点击图片
    func OnClickMyBar(sender:UITapGestureRecognizer){
        var baike:WebView = WebView.WebViewInit()
        baike.strWebTitle = "我们的酒吧"
        baike.WebUrl="http://www.dianping.com/shop/17187839"
        rootController.showOrhideToolbar(false)
        baike.showToolbar = true
        self.navigationController?.pushViewController(baike, animated: true)
    }
    //点击音乐人
    func OnClickMusic(sender:UITapGestureRecognizer){
        var baike:WebView = WebView.WebViewInit()
        baike.strWebTitle = "音乐人推荐"
        baike.WebUrl="http://m.weibo.cn/u/1278678934"
        rootController.showOrhideToolbar(false)
        baike.showToolbar = true
        self.navigationController?.pushViewController(baike, animated: true)
    }
    
    //@MARK:处理界面详细信息的打开
    var recipesCollection:RecipesCollection!
    
    //点击图片
    func OnClickImageSence(sender:UITapGestureRecognizer){
        var sence = sender.self.view as! UIImageView!
        CallShowSence(sence.tag)
    }
    
    //点击无图的话题时
    @IBAction func OnClickSence(sender:UIButton){
        CallShowSence(sender.tag)
    }
    
    func CallShowSence(tag:Int){
        var item:NSDictionary = JsonData[tag] as! NSDictionary
        // RecipesCollectionInit 初始化了一个stroyboard
        recipesCollection = RecipesCollection.RecipesCollectionInit()
        recipesCollection.NavigationController = self.navigationController
        recipesCollection.strSenceTitle = (item["title"] as! String)
        recipesCollection.SenceItems = (item["data"] as! NSArray)
        self.navigationController?.pushViewController(recipesCollection, animated: true)
        rootController.showOrhideToolbar(false)
    }
    
    //@MARK:点击鸡尾酒百科
    
    @IBAction func OnClickBaike(sender:UIButton){
        var baike:WebView = WebView.WebViewInit()
        baike.strWebTitle = "鸡尾酒百科"
        baike.WebUrl="http://baike.baidu.com/subview/10115/10886479.htm"
        rootController.showOrhideToolbar(false)
        baike.showToolbar = true
        self.navigationController?.pushViewController(baike, animated: true)
    }
    
    //@MARK:点击查看
    @IBAction func viewStore(sender:UIButton){
        var baike:WebView = WebView.WebViewInit()
        baike.strWebTitle = "商城"
        baike.WebUrl="http://?????"
        rootController.showOrhideToolbar(false)
        baike.showToolbar = true
        self.navigationController?.pushViewController(baike, animated: true)
    }
    
    //@MARK:处理向下向上滚动影藏控制栏
    var lastPos:CGFloat = 0
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        lastPos = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var off = scrollView.contentOffset.y
        if((off-lastPos)>50 && off>50){//向下了
            lastPos = off
            rootController.showOrhideToolbar(false)
        }else if((lastPos-off)>50){
            lastPos = off
            rootController.showOrhideToolbar(true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
