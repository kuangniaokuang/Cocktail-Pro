//
//  RecipesCollection.swift
//  smartmixer
//
//  Created by 姚俊光 on 14-9-1.
//  Copyright (c) 2014年 Smart Group. All rights reserved.
//

import UIKit
import CoreData
import Foundation

@available(iOS 8.0, *)
class RecipesCollection: UIViewController,UIScrollViewDelegate {
    
    //@MARK:容器对象
    @IBOutlet var icollectionView:UICollectionView!
    //标题的导航，一般不显示
    @IBOutlet var senceTitle:UINavigationItem!
    //没有找到数据时的显示提示
    @IBOutlet var nodataFind:UILabel!
    
    //@MARK:酒单页的参数设置
    //搜索参数设置部分
    var recipesSearch:RecipesSearch! = nil
    //当前的选中分类
    var catagorySearch:Int! = 0
    //该导航需要设置的
    var NavigationController:UINavigationController!
    
    //@MARK:场景显示时的需要设置的参数
    //显示的标题,这是为场景显示准备的
    var strSenceTitle:String="鸡尾酒Pro"
    //需要集中显示的项目
    var SenceItems:NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(senceTitle != nil){
            senceTitle.title = strSenceTitle
        }
    }
    
    
    //@MARK:内部自初始化一个实例
    class func RecipesCollectionInit()->RecipesCollection{
        var recipesCollection = UIStoryboard(name: "Recipes"+deviceDefine, bundle: nil).instantiateViewControllerWithIdentifier("recipesCollection") as! RecipesCollection
        return recipesCollection
    }
    
    //@MARK:摇一摇的功能部分
    //是不是启用摇一摇，作为场景页显示的时候不不可以的
    override func canBecomeFirstResponder() -> Bool {
        if(recipesSearch != nil){
            return true
        }else{
            return false
        }
    }
    // 动作开始 调用
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        // 晃动
        if (motion == UIEventSubtype.MotionShake) {
            let sectionInfo = self.fetchedItemsController.sections
            let item = sectionInfo![0]
            var totle:UInt32 = UInt32(item.numberOfObjects)
            let num = arc4random_uniform(totle)
            var indexPath = NSIndexPath(forRow: Int(num), inSection: 0)
            var recipeDetail = UIStoryboard(name: "Recipes", bundle: nil).instantiateViewControllerWithIdentifier("recipeDetail") as! RecipeDetailPhone
            recipeDetail.CurrentData = self.fetchedItemsController.objectAtIndexPath(indexPath) as! Recipe
            self.NavigationController.pushViewController(recipeDetail, animated: true)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.resignFirstResponder()
        super.viewWillAppear(animated)
        
    }
    
    //返回
    @IBAction func goback(sender:UINavigationItem){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //@MARK:处理向下向上滚动影藏控制栏
    var lastPos:CGFloat = 0
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        lastPos = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if(SenceItems == nil){//非场景调用时的处理
            var off = scrollView.contentOffset.y
            if((off-lastPos)>50 && off>50){//向下了
                lastPos = off
                rootController.showOrhideToolbar(false)
            }else if((lastPos-off)>50){
                lastPos = off
                rootController.showOrhideToolbar(true)
            }
        }
    }
    
    //@MARK:collectionView的显示处理
    
    func ReloadData(){
        _fetchedItemsController = nil
        icollectionView.reloadData()
        icollectionView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedItemsController.sections
        let item = sectionInfo![section]
        if(item.numberOfObjects==0){
            nodataFind.hidden=false
        }else{
            nodataFind.hidden=true
        }
        return item.numberOfObjects
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        //自定义cell RecipeThumbail.swift
        var viewCell = collectionView.dequeueReusableCellWithReuseIdentifier("recipe-thumbnail", forIndexPath: indexPath) as! RecipeThumbail
        //数据抽出部分
        let item = self.fetchedItemsController.objectAtIndexPath(indexPath) as! Recipe
        //自定义cell赋值
        viewCell.SetDataContent(item)
        return viewCell
    }
    
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
        rootSideMenu.needSwipeShowMenu = false
        if(deviceDefine==""){
            var recipeDetail = RecipeDetailPhone.RecipesDetailPhoneInit()
            recipeDetail.CurrentData = self.fetchedItemsController.objectAtIndexPath(indexPath) as! Recipe
            self.NavigationController.pushViewController(recipeDetail, animated: true)
        }else{//ipad
            var recipeDetail = RecipeDetailPad.RecipeDetailPadInit()
            recipeDetail.CurrentData = self.fetchedItemsController.objectAtIndexPath(indexPath) as! Recipe
            self.NavigationController.pushViewController(recipeDetail, animated: true)
        }
        
    }
    
    //@MARK:数据准备的部分
    var fetchedItemsController: NSFetchedResultsController {
        if (_fetchedItemsController == nil) {
            let fetchRequest = NSFetchRequest()
            fetchRequest.entity = NSEntityDescription.entityForName("Recipe", inManagedObjectContext: managedObjectContext)
            if(catagorySearch == -1){
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "coverd", ascending: false),NSSortDescriptor(key: "id", ascending: false)]
            }else{
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
            }
            var conditionStr:String = ""
            if(recipesSearch != nil){//这里是主界面的调用
                //关键字
                if(recipesSearch.keyWord != ""){//关键字
                    conditionStr = "(name CONTAINS[cd] '\(recipesSearch.keyWord)' OR nameEng CONTAINS[cd] '\(recipesSearch.keyWord)') AND "
                }
                //口感部分
                var conditionSeg:String = ""
                for var tag:Int = 0; tag<recipesSearch.keyTaste.count ;tag+=1 {
                    if(recipesSearch.keyTaste[tag] == true){
                        conditionSeg += " taste==\(tag) or"
                    }
                }
                if(conditionSeg != ""){
                    conditionSeg = conditionSeg.substringToIndex(conditionSeg.startIndex.advancedBy(conditionSeg.characters.count-3))
                    conditionStr += "(\(conditionSeg)) AND "
                }
                //技巧部分
                conditionSeg = ""
                for var tag:Int = 0; tag<recipesSearch.keySkill.count ;tag+=1 {
                    if(recipesSearch.keySkill[tag] == true){
                        conditionSeg += " skill==\(tag) or"
                    }
                }
                if(conditionSeg != ""){
                    conditionSeg = conditionSeg.substringToIndex(conditionSeg.startIndex.advancedBy(conditionSeg.characters.count-3))
                    conditionStr += "(\(conditionSeg)) AND "
                }
                
                //引用时间部分
                conditionSeg = ""
                for var tag:Int = 0; tag<recipesSearch.keyDrinkTime.count ;tag+=1 {
                    if(recipesSearch.keyDrinkTime[tag] == true){
                        conditionSeg += " drinktime==\(tag) or"
                    }
                }
                if(conditionSeg != ""){
                    conditionSeg = conditionSeg.substringToIndex(conditionSeg.startIndex.advancedBy(conditionSeg.characters.count-3))
                    conditionStr += "(\(conditionSeg)) AND "
                }
                
                //分类
                if(catagorySearch > 0){
                    conditionStr += "catagoryId==\(catagorySearch) AND "
                }
                //酒精度
                conditionStr += "alcohol<=\(recipesSearch.keyAlcohol) AND "
                //难度
                conditionStr += "difficulty<=\(recipesSearch.keyDifficulty)"
            } else if(SenceItems != nil) {//这里是用户调用场景显示的部分
                for item in SenceItems {
                    conditionStr += " id=\((item as! Int)) or "
                }
                var end = conditionStr.startIndex.advancedBy(conditionStr.characters.count-4)
                conditionStr = conditionStr.substringToIndex(end)
            }
            if(conditionStr != ""){
                fetchRequest.predicate = NSPredicate(format: conditionStr)
            }
            let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            _fetchedItemsController = aFetchedResultsController
            
            //http请求数据
            /*
            var request = HTTPTask()
            var url = "http://www.tobaking.com/api/request.php"
            request.GET(url, parameters: ["method":"search","search_word":"蛋糕","search_type":1,"page_size":1,"page":1], success: {(response:HTTPResponse) -> Void in
                if response.responseObject != nil{
                    let data = response.responseObject as! NSData
                    let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                    print("response:\(str)")
                }
            }, failure: {(err:NSError,response:HTTPResponse?) -> Void in
                print("error:\(err)")
            })
            */
            do{
                try _fetchedItemsController?.performFetch()
            }catch{
                abort()
            }
            }
            return _fetchedItemsController!
    }
    var _fetchedItemsController: NSFetchedResultsController? = nil
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
