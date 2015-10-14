//
//  FirstViewController.swift
//  smartmixer
//
//  Created by Koulin Yuan on 8/13/14.
//  Copyright (c) 2014 Smart Group. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 8.0, *)
class Recipes: UIViewController, SearchBeginDelegate ,NumberDelegate,UISearchBarDelegate{
    
    @IBOutlet var parentView: UIView?
    
    @IBOutlet var searchView:UIView?
    
    @IBOutlet var CollectionView: UIView?
    
    @IBOutlet var hCondition: NSLayoutConstraint?
    
    @IBOutlet var searchIco:UIBarButtonItem?
    
    @IBOutlet var navTitle:UINavigationItem!
    
    @IBOutlet var senceTipsButton:UIButton!
    
    @IBOutlet var hSenceTips: NSLayoutConstraint?
    
    var menuVC:SideMenuController?
    
    var isCategoryTableViewHidden = true;
    
    //搜索参数设置部分
    var recipesSearch:RecipesSearch?
    
    //显示的视图
    var recipesCollection:RecipesCollection? = nil
    
    var searchBar:UISearchBar?
    
    var titleView:UIView?
    
    class func RecipesInit()->UIViewController{
        var recipes = UIStoryboard(name: "Recipes"+deviceDefine, bundle: nil).instantiateInitialViewController()
        return recipes!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (rootSideMenu.SideView as! CategoryMenu).delegate = self
        if(navTitle != nil){
            var lable = UILabel()
            lable.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
            lable.textColor = UIColor.whiteColor()
            lable.textAlignment = NSTextAlignment.Center
            lable.text = navTitle.title!
            navTitle.titleView = lable
            
        }
        searchBar = UISearchBar()
        searchBar?.placeholder = "例如：热吻"
        searchBar?.delegate = self
        
        var left = UIBarButtonItem(image: UIImage(named: "menu"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("showLeft:"))
        self.navigationItem.leftBarButtonItem = left
        
        recipesSearch = self.childViewControllers[1] as? RecipesSearch
        recipesSearch?.delegate = self
        var rect  = CGRect(x: searchView!.frame.origin.x, y: searchView!.frame.origin.y, width: searchView!.frame.width, height: 0)
        searchView?.frame = rect
        searchView?.hidden = true
        
        recipesCollection = self.childViewControllers[0] as? RecipesCollection
        recipesCollection?.recipesSearch = recipesSearch
        recipesCollection?.NavigationController = self.navigationController
    }
    
    func showLeft(sender:UIButton){
        if (rootSideMenu != nil){
            rootSideMenu.showLeftViewController(true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        rootController.showOrhideToolbar(true)
    }
    
    func scrollToTop(){
        recipesCollection?.icollectionView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    func NumberAction(sender:UIViewController,num Number:Int){
        recipesCollection?.catagorySearch = Number;
        recipesCollection?.ReloadData()
    }
    
    //点击搜索按钮
    @IBAction func showSearchMore(sender:UIBarButtonItem){
        self.searchView!.hidden = false
        titleView = self.navigationItem.titleView
        self.navigationItem.titleView = searchBar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancleSearch:")
        UIView.animateWithDuration(0.2, animations: {
            self.hCondition!.constant = 280
            self.parentView!.layoutIfNeeded()
        })
        
    }
    
    func cancleSearch(sender:UIBarButtonItem){
        self.recipesSearch?.resetCondition()
        self.searchBar?.text=""
        recipesCollection?.catagorySearch = 0;
        recipesCollection?.ReloadData()
        UIView.animateWithDuration(0.2, animations: {
            self.hCondition!.constant = 0
            self.parentView!.layoutIfNeeded()
            }, completion: {_ in
                self.searchView!.hidden = true
                self.navigationItem.titleView = self.titleView
                self.navigationItem.rightBarButtonItem = self.searchIco
        })
    }
    
    //点击搜索按钮
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    //点击搜索回车按钮
    func SearchBeginAction(sender: RecipesSearch,hide:Bool) {
        recipesSearch!.keyWord = searchBar!.text!
        recipesCollection!.ReloadData()
        if(hide){
            UIView.animateWithDuration(0.2, animations: {
                self.hCondition!.constant = 0
                self.parentView!.layoutIfNeeded()
                }, completion: {_ in
                    self.searchView!.hidden = true
                    self.navigationItem.titleView = self.titleView
                    self.navigationItem.rightBarButtonItem = self.searchIco
            })
        }
    }
    
}


