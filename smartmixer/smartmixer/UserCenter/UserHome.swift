//
//  UserHome.swift
//  smartmixer
//
//  Created by 姚俊光 on 14/9/29.
//  Copyright (c) 2014年 smarthito. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 8.0, *)
class UserHome: UIViewController,UIScrollViewDelegate,UITableViewDelegate,HistoryCellDelegate,NSFetchedResultsControllerDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    //用户信息的View
    @IBOutlet var userInfoLayer:UIView!
    
    //用户背景图片
    @IBOutlet var userInfoBg:UIImageView!
    
    //用户信息距顶部的控制
    @IBOutlet var userInfoframe: UIView!
    
    //信息的滚动
    @IBOutlet var scollViewMap:UIScrollView!
    
    //概览信息
    @IBOutlet var sumInfo:UILabel!
    
    //用户名字
    @IBOutlet var userName:UILabel!
    
    //用户头像
    @IBOutlet var userImage:UIImageView!
    
    //点击还原的我按钮
    @IBOutlet var myButton:UIButton!
    
    //没有数据时的提示
    @IBOutlet var nodataTip:UILabel!
    
    //历史信息的table
    @IBOutlet var historyTableView:UITableView!
    
    var clickGesture:UITapGestureRecognizer!
    
    class func UserHomeRoot()->UIViewController{
        var userCenterController = UIStoryboard(name:"UserCenter"+deviceDefine,bundle:nil).instantiateInitialViewController()
        return userCenterController!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileManager = NSFileManager.defaultManager()
        if(fileManager.isReadableFileAtPath(applicationDocumentsPath+"/mybg.png")){
            userInfoBg.image = UIImage(contentsOfFile: applicationDocumentsPath+"/mybg.png")
        }
        
        userImage.image = UIImage(contentsOfFile: applicationDocumentsPath+"/myimage.png")
        userName.text = NSUserDefaults.standardUserDefaults().stringForKey("UserName")!
        
        self.userInfoframe.userInteractionEnabled = true
        clickGesture = UITapGestureRecognizer()
        clickGesture.addTarget(self, action: Selector("changeHomebg:"))
        clickGesture?.delegate = self
        self.userInfoframe.addGestureRecognizer(clickGesture!)
        scollViewMap.contentSize = CGSize(width: 0, height: 350+CGFloat(numberOfObjects*50))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        var UserCook = NSUserDefaults.standardUserDefaults().integerForKey("UserCook")
        var UserFavor = NSUserDefaults.standardUserDefaults().integerForKey("UserFavor")
        var UserHave = NSUserDefaults.standardUserDefaults().integerForKey("UserHave")
        var UserContainer = NSUserDefaults.standardUserDefaults().integerForKey("UserContainer")
        sumInfo.text = "\(UserFavor)个收藏，\(UserCook)次制作，\(UserHave)种材料，\(UserContainer)种器具"
        userImage.image = UIImage(contentsOfFile: applicationDocumentsPath+"/myimage.png")
        userName.text = NSUserDefaults.standardUserDefaults().stringForKey("UserName")!
        scollViewMap.contentSize = CGSize(width: 0, height: 350+CGFloat(numberOfObjects*50))
        rootController.showOrhideToolbar(true)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //@MARK:修改主页的背景选取照片
    var imagePicker:UIImagePickerController!
    var popview:UIPopoverController!
    //修改主页的背景图片
    func changeHomebg(sender:UITapGestureRecognizer){
        if(scollViewMap.contentOffset.y>10){
            UIView.animateWithDuration(0.3, animations: {
                self.userInfoframe.frame = CGRect(x: self.userInfoframe.frame.origin.x, y: 0, width: self.userInfoframe.frame.width, height: self.userInfoframe.frame.height)
                self.userInfoLayer.alpha = 1
                self.myButton.hidden = true
                self.setalpha = false
                self.view.layoutIfNeeded()
            })
            self.scollViewMap.contentOffset.y = 0
        }else{
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
            imagePicker.tabBarItem.title="请选择背景图片"
            if(deviceDefine==""){
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }else{
                popview = UIPopoverController(contentViewController: imagePicker)
                popview.presentPopoverFromRect(CGRect(x: 512, y: 50, width: 10, height: 10), inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
            }
            
        }
    }
    
    //写入Document中
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var image = info["UIImagePickerControllerOriginalImage"] as! UIImage
        userInfoBg.image = image
        var imageData = UIImagePNGRepresentation(image)
        imageData!.writeToFile(applicationDocumentsPath+"/mybg.png", atomically: false)
        self.dismissViewControllerAnimated(true, completion: nil)
        if(osVersion<8 && deviceDefine != ""){
            popview.dismissPopoverAnimated(true)
        }
    }
    
    //@MARK:点击商城
    @IBAction func OnStoreClick(sender:UIButton){
        var baike:WebView = WebView.WebViewInit()
        baike.strWebTitle = "商城"
        baike.WebUrl="http://www.smarthito.com"
        rootController.showOrhideToolbar(false)
        baike.showToolbar = true
        self.navigationController?.pushViewController(baike, animated: true)
    }
    
    //@MARK:点击设置
    var aboutview:UIViewController!
    @IBAction func OnSettingClick(sender:UIButton){
        if(deviceDefine==""){
            aboutview = AboutViewPhone.AboutViewPhoneInit()
        }else{
            aboutview = AboutViewPad.AboutViewPadInit()
        }
        self.navigationController?.pushViewController(aboutview, animated: true)
        rootController.showOrhideToolbar(false)
    }
    
    //#MARK：这里是处理滚动的处理向下向上滚动影藏控制栏
    var lastPos:CGFloat = 0
    
    //滚动开始记录开始偏移
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        lastPos = scrollView.contentOffset.y
    }

    
    var setalpha:Bool=false
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var off = scrollView.contentOffset.y
        if(off<=240 && off>0){//在区间0~240需要渐变处理
            userInfoframe.frame = CGRect(x: userInfoframe.frame.origin.x, y: -off, width: userInfoframe.frame.width, height: userInfoframe.frame.height)
            userInfoLayer.alpha = 1-off/240
            myButton.hidden = true
            setalpha = false
        }else if(off>240 && setalpha==false){//大于240区域
            userInfoframe.frame = CGRect(x: userInfoframe.frame.origin.x, y: -240, width: userInfoframe.frame.width, height: userInfoframe.frame.height)
            userInfoLayer.alpha = 0
            myButton.hidden = false
            setalpha = true
        }else if(off<0){
            userInfoframe.frame = CGRect(x: userInfoframe.frame.origin.x, y: 0, width: userInfoframe.frame.width, height: userInfoframe.frame.height)
            self.userInfoLayer.alpha = 1
            self.myButton.hidden = true
            self.setalpha = false
        }
        /**/
        if((off-lastPos)>50 && off>50){//向下了
            lastPos = off
            rootController.showOrhideToolbar(false)
        }else if((lastPos-off)>70){
            lastPos = off
            rootController.showOrhideToolbar(true)
        }
    }
    var numberOfObjects:Int=0
    //@MARK：这里是处理显示数据的
    //告知窗口现在有多少个item需要添加
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        let sectionInfo = self.fetchedResultsController.sections
        let item = sectionInfo![section]
        numberOfObjects = item.numberOfObjects
        if(numberOfObjects==0){
            nodataTip.hidden = false
        }else{
            nodataTip.hidden = true
        }
        historyTableView.contentSize = CGSize(width: 0, height: CGFloat(numberOfObjects*50))
        return item.numberOfObjects
    }
    
    //处理单个View的添加
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        let item = self.fetchedResultsController.objectAtIndexPath(indexPath) as! History
        var indentifier = "his-cook"
        if(item.type==1){
            indentifier="his-addfaver"
        }else if(item.type==2){
            indentifier="his-addhave"
        }else if(item.type==3){
            indentifier="his-addhave"
        }
        
        var cell :HistoryCell = tableView.dequeueReusableCellWithIdentifier(indentifier) as! HistoryCell
        if(deviceDefine==""){
            cell.scroll.contentSize = CGSize(width: 380, height: 50)
        }else{
            //cell.scroll.contentSize = CGSize(width: 1104, height: 50)
        }
        cell.name.text = item.name
        cell.thumb.image = UIImage(named: item.thumb)
        cell.time.text = formatDateString(item.addtime)
        cell.delegate = self
        return cell
    }
    
    
    var lastDayString:String!=nil
    
    func formatDateString(date:NSDate)->String{
        var formatter = NSDateFormatter()
        formatter.dateFormat="yyyy.MM.dd"
        var newstring = formatter.stringFromDate(date)
        if(newstring != lastDayString){
            lastDayString = newstring
            return lastDayString
        }else{
            return "."
        }
    }
    
    
    //要删除某个
    func historyCell(sender:HistoryCell){
        skipUpdate = true
        var indexPath:NSIndexPath=self.historyTableView.indexPathForCell(sender)!
        let item = self.fetchedResultsController.objectAtIndexPath(indexPath) as! History
        managedObjectContext.deleteObject(item)
        do{
            try managedObjectContext.save()
        }catch{
            abort()
        }
        self.historyTableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
    }
    //选中某个需要显示
    func historyCell(sender:HistoryCell,show ShowCell:Bool){
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        rootController.showOrhideToolbar(false)
        var indexPath:NSIndexPath=self.historyTableView.indexPathForCell(sender)!
        let item = self.fetchedResultsController.objectAtIndexPath(indexPath) as! History
        if(item.type==0||item.type==1){
            var recipe=DataDAO.getOneRecipe(item.refid.integerValue)
            if(deviceDefine==""){
                var recipeDetail = RecipeDetailPhone.RecipesDetailPhoneInit()
                recipeDetail.CurrentData = recipe
                self.navigationController?.pushViewController(recipeDetail, animated: true)
            }else{
                var recipeDetail = RecipeDetailPad.RecipeDetailPadInit()
                recipeDetail.CurrentData = recipe
                self.navigationController?.pushViewController(recipeDetail, animated: true)
            }
        }else if(item.type==2){
            var materials = IngredientDetail.IngredientDetailInit()
            materials.ingridient=DataDAO.getOneIngridient(item.refid.integerValue)
            self.navigationController?.pushViewController(materials, animated: true)
        }else if(item.type==3){
            var container = ContainerDetail.ContainerDetailInit()
            container.CurrentContainer = DataDAO.getOneContainer(item.refid.integerValue)
            self.navigationController?.pushViewController(container, animated: true)
        }
    }
    
    //@MARK:历史数据的添加处理
    class func addHistory(type:Int,id refId:Int,thumb imageThumb:String,name showName:String){
        var history = NSEntityDescription.insertNewObjectForEntityForName("History", inManagedObjectContext: managedObjectContext) as! History
        history.type = type
        history.refid = refId
        history.thumb = imageThumb
        history.name = showName
        history.addtime = NSDate()
        if(type==0){
            var usernum = NSUserDefaults.standardUserDefaults().integerForKey("UserCook")+1
            NSUserDefaults.standardUserDefaults().setInteger(usernum, forKey: "UserCook")
            do{
                try managedObjectContext.save()
            }catch{
                abort()
            }
        }else if(type==1){
            var usernum = NSUserDefaults.standardUserDefaults().integerForKey("UserFavor")+1
            NSUserDefaults.standardUserDefaults().setInteger(usernum, forKey: "UserFavor")
        }else if(type==2){//添加了材料的拥有
            var usernum = NSUserDefaults.standardUserDefaults().integerForKey("UserHave")+1
            NSUserDefaults.standardUserDefaults().setInteger(usernum, forKey: "UserHave")
            DataDAO.updateRecipeCoverd(refId, SetHave: true)
        }else{
            var usernum = NSUserDefaults.standardUserDefaults().integerForKey("UserContainer")+1
            NSUserDefaults.standardUserDefaults().setInteger(usernum, forKey: "UserContainer")
        }
        
    }
    //历史数据的删除
    class func removeHistory(type:Int,id refId:Int){
        if(type==0){
            var usernum = NSUserDefaults.standardUserDefaults().integerForKey("UserCook")-1
            NSUserDefaults.standardUserDefaults().setInteger(usernum, forKey: "UserCook")
        }else if(type==1){
            var usernum = NSUserDefaults.standardUserDefaults().integerForKey("UserFavor")-1
            NSUserDefaults.standardUserDefaults().setInteger(usernum, forKey: "UserFavor")
        }else if(type==2){
            var usernum = NSUserDefaults.standardUserDefaults().integerForKey("UserHave")-1
            NSUserDefaults.standardUserDefaults().setInteger(usernum, forKey: "UserHave")
            DataDAO.updateRecipeCoverd(refId, SetHave: false)
        }else{
            var usernum = NSUserDefaults.standardUserDefaults().integerForKey("UserContainer")-1
            NSUserDefaults.standardUserDefaults().setInteger(usernum, forKey: "UserContainer")
        }
    }
    
    //@MARK:数据的读取
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("History", inManagedObjectContext: managedObjectContext)
        fetchRequest.fetchBatchSize = 30
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "addtime", ascending: false)]
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        _fetchedResultsController = aFetchedResultsController
        _fetchedResultsController?.delegate = self
        do{
            try _fetchedResultsController?.performFetch()
        }catch{
            abort()
        }
        return _fetchedResultsController!
    }
    
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    var skipUpdate:Bool=false
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        if(skipUpdate){
            skipUpdate=false
        }else{
            _fetchedResultsController = nil
            historyTableView.reloadData()
            lastDayString=nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
