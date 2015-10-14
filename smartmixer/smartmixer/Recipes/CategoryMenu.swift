//
//  SideMenuControllerTableViewController.swift
//  smartmixer
//
//  Created by 姚俊光 on 14/9/21.
//  Copyright (c) 2014年 smarthito. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 8.0, *)
class CategoryMenu: UIViewController {
    
    class func CategoryMenuInit()->CategoryMenu{
        var menu = UIStoryboard(name: "Recipes"+deviceDefine, bundle: nil).instantiateViewControllerWithIdentifier("categoryMenu") as! CategoryMenu
        return menu
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
    }
    
    var delegate:NumberDelegate!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = (self.fetchedResultsController.sections)! [section]
        return sectionInfo.numberOfObjects+2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var categoryCell :CategoryCell = tableView.dequeueReusableCellWithIdentifier("categoryCell") as! CategoryCell
        categoryCell.backgroundColor = UIColor.clearColor()
        var newview = RadiusView(frame: categoryCell.frame)
        newview.backgroundColor = UIColor.clearColor()
        categoryCell.selectedBackgroundView = newview
        categoryCell.cellname.highlightedTextColor = UIColor(red: 241/255, green: 77/255, blue: 66/255, alpha: 1)
        if(indexPath.row==0 && indexPath.section==0){
            categoryCell.cellname.text = "全部 All"
            categoryCell.tag = 0
            tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.Top)
        }else if(indexPath.row==1 && indexPath.section==0){
            categoryCell.cellname.text = "我的酒单 Mine"
            categoryCell.tag = -1
        }else{
            var index = NSIndexPath(forRow: indexPath.row-2, inSection: indexPath.section)
            let item = self.fetchedResultsController.objectAtIndexPath(index) as! Category
            categoryCell.cellname.text = "\(item.name) \(item.nameEng)"
            categoryCell.tag = item.id.integerValue
        }

        return categoryCell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        var cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!
        if(self.delegate != nil){
            self.delegate.NumberAction(self, num: cell.tag)
        }
        if (rootSideMenu != nil){
            rootSideMenu.hideSideViewController()
        }
    }
    
    //下载分类的
    var fetchedResultsController: NSFetchedResultsController {
        if (_fetchedResultsController != nil) {
            return _fetchedResultsController!
            }
            
            let fetchRequest = NSFetchRequest()
            fetchRequest.entity = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext)
            fetchRequest.fetchBatchSize = 30
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true),NSSortDescriptor(key: "id", ascending: true)]
            fetchRequest.predicate = NSPredicate(format: "type = 0")
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
