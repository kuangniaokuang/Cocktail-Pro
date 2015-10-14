//
//  MaterialCollection.swift
//  smartmixer
//
//  Created by 姚俊光 on 14-9-2.
//  Copyright (c) 2014年 Smart Group. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 8.0, *)
class IngredientCollection: UICollectionViewController {
    
    //该导航需要设置的
    var NavigationController:UINavigationController!

    var icollectionView:UICollectionView!
    
    @IBOutlet var navtitle:UINavigationItem!
    
    //分类的id
    var CatagoryId:Int = 0
    //分类的显示名称
    var catagoryName:String = ""
    
    class func IngredientCollectionInit()->IngredientCollection{
        var ingredientCollection = UIStoryboard(name: "Ingredients"+deviceDefine, bundle: nil).instantiateViewControllerWithIdentifier("ingredientCollection") as! IngredientCollection
        return ingredientCollection
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(navtitle != nil){
            navtitle.title = catagoryName
        }
        if(deviceDefine==""){//添加向右滑动返回
            let slideback =  UISwipeGestureRecognizer()
            slideback.addTarget(self, action: "SwipeToBack:")
            slideback.direction = UISwipeGestureRecognizerDirection.Right
            self.view.addGestureRecognizer(slideback)
            self.view.userInteractionEnabled = true
        }
        
    }
    
    func SwipeToBack(sender:UISwipeGestureRecognizer){
        self.NavigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func back(sender: UIBarButtonItem) {
        self.NavigationController?.popViewControllerAnimated(true)
    }
    
    //处理向下向上滚动影藏控制栏
    var lastPos:CGFloat = 0
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        lastPos = scrollView.contentOffset.y
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if(deviceDefine != "" ){
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
    
    //@MARK:数据显示处理部分
    func reloadData(){
        _fetchedResultsController = nil
        icollectionView.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        icollectionView = collectionView
        let sectionInfo = self.fetchedResultsController.sections
        let item = sectionInfo![section]
        return item.numberOfObjects
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("ingredientThumb", forIndexPath: indexPath) as! IngredientThumb
        if(CatagoryId==0){
            let item = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Container
            cell.SetContainer(item)
        }else{
            let item = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Ingridient
            cell.SetContentData(item)
        }
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if(CatagoryId==0){
            var container = ContainerDetail.ContainerDetailInit()
            let item = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Container
            container.CurrentContainer = item
            self.NavigationController.pushViewController(container, animated: true)
        }else{
            var materials = IngredientDetail.IngredientDetailInit()
            let item = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Ingridient
            materials.ingridient=item
            self.NavigationController.pushViewController(materials, animated: true)
        }
        if(deviceDefine != ""){
            rootController.showOrhideToolbar(false)
        }
    }
    
    //@MARK:数据的读取
    var fetchedResultsController: NSFetchedResultsController {
        
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
            }
            
            let fetchRequest = NSFetchRequest()
            if(CatagoryId == 0){
                fetchRequest.entity = NSEntityDescription.entityForName("Container", inManagedObjectContext: managedObjectContext)
                fetchRequest.fetchBatchSize = 20
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
            }else{
                fetchRequest.entity = NSEntityDescription.entityForName("Ingridient", inManagedObjectContext: managedObjectContext)
                fetchRequest.fetchBatchSize = 30
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
                if(CatagoryId>0){
                    fetchRequest.predicate = NSPredicate(format: "categoryId == \(CatagoryId) ")
                }else{
                    fetchRequest.predicate = NSPredicate(format: "(name CONTAINS[cd] '\(catagoryName)' OR nameEng CONTAINS[cd] '\(catagoryName)')")
                }
            }
            let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            _fetchedResultsController = aFetchedResultsController

            do{
                try _fetchedResultsController?.performFetch()
            }catch{
                abort()
            }
            return _fetchedResultsController!
    }
    
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    
}
