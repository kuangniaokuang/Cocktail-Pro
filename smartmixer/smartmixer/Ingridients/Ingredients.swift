//
//  Materials.swift
//  smartmixer
//
//  Created by 姚俊光 on 14-8-20.
//  Copyright (c) 2014年 Smart Group. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 8.0, *)
class Ingredients: UIViewController , NSFetchedResultsControllerDelegate,UISearchBarDelegate{
    
    @IBOutlet var itableView:UITableView!
    
    @IBOutlet var searchbar:UISearchBar!
    
    //用户修正TableView的上端距离
    @IBOutlet var hCondition: NSLayoutConstraint!
    
    var ingredientCollection:IngredientCollection! = nil
    
    var numberOfitems:Int = 0
    
    class func IngredientsRoot()->UIViewController{
        var ingridientController = UIStoryboard(name:"Ingredients"+deviceDefine,bundle:nil).instantiateInitialViewController()
        return ingridientController!
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if(deviceDefine != ""){//ipad
            ingredientCollection = IngredientCollection.IngredientCollectionInit()
            ingredientCollection.NavigationController = self.navigationController
            ingredientCollection.view.frame = CGRect(x: 1024-770, y: 60, width: 760, height: self.view.frame.height)
            self.view.addSubview(ingredientCollection.view)
            var index = NSIndexPath(forRow: 0, inSection: 0)
            itableView!.selectRowAtIndexPath(index, animated: false, scrollPosition: UITableViewScrollPosition.Top)
        }
        itableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        rootController.showOrhideToolbar(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if(deviceDefine==""){
            itableView.contentSize = CGSize(width: 320, height:200+numberOfitems*60)
        }else{
            itableView.contentSize = CGSize(width: 250, height:250+numberOfitems*80)
        }
        if(osVersion>=8 && self.hCondition != nil){
            self.hCondition.constant = -60
        }
        self.view.layoutIfNeeded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //@MARK:搜索框的处理
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    //取消按钮
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text=""
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    //搜索按钮按下
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if(deviceDefine==""){
            ingredientCollection = IngredientCollection.IngredientCollectionInit()
            ingredientCollection.NavigationController = self.navigationController
            ingredientCollection.CatagoryId = -1
            ingredientCollection.catagoryName = searchBar.text!
            self.navigationController?.pushViewController(ingredientCollection!, animated: true)
            rootController.showOrhideToolbar(false)
        }else{
            ingredientCollection.CatagoryId = -1
            ingredientCollection.catagoryName = searchBar.text!
            ingredientCollection.reloadData()
        }
        
    }
    
    //告知窗口现在有多少个item需要添加
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        let sectionInfo = self.fetchedResultsController.sections
        let item = sectionInfo![section]
        numberOfitems = item.numberOfObjects + 1
        return numberOfitems
    }
    
    //处理单个View的添加
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        var tableCell:IngredientCategory = tableView.dequeueReusableCellWithIdentifier("categoryCell") as! IngredientCategory
        if(indexPath.row==0){
            tableCell.title.text = "器具"
            tableCell.title_eng.text = "Appliances"
            tableCell.tag = 0
            tableCell.thumb.image = UIImage(named: "C_Appliances.jpg")
        }else{
            var index = NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)
            let item = self.fetchedResultsController.objectAtIndexPath(index) as! Category
            tableCell.title.text = item.name
            tableCell.title_eng.text = item.nameEng
            tableCell.tag = item.id.integerValue
            tableCell.thumb.image = UIImage(named: item.thumb)
        }
        tableCell.selectedBackgroundView = UIView(frame: tableCell.frame)
        tableCell.selectedBackgroundView!.backgroundColor = UIColor.whiteColor()
        tableCell.title.highlightedTextColor = UIColor.redColor()
        tableCell.title_eng.highlightedTextColor = UIColor.redColor()
        return tableCell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! IngredientCategory
        if(deviceDefine==""){
            ingredientCollection = IngredientCollection.IngredientCollectionInit()
            ingredientCollection.NavigationController = self.navigationController
            ingredientCollection.CatagoryId = cell.tag
            ingredientCollection.catagoryName = cell.title.text!
            self.navigationController?.pushViewController(ingredientCollection, animated: true)
            rootController.showOrhideToolbar(false)
        }else{
            ingredientCollection.CatagoryId = cell.tag
            ingredientCollection.reloadData()
        }
    }
    
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext)
        fetchRequest.fetchBatchSize = 30
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true),NSSortDescriptor(key: "id", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "type == 1")
        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
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
