//
//  RootViewController.swift
//  smartmixer
//
//  Created by kingzhang on 8/24/14.
//  Copyright (c) 2014 Smart Group. All rights reserved.
//

import UIKit

//@MARK:一些用得着的静态变量
//这个是基础的控制类
@available(iOS 8.0, *)
var rootController:RootViewController!
//这是滑动分类的管理
@available(iOS 8.0, *)
var rootSideMenu:SideMenuController!
//
let appID:String = "923816796"
//
let itunesLink:String="https://itunes.apple.com/cn/app/ji-wei-jiu-pro/id923816796?mt=8"

//设备类型
var deviceDefine:String="_ipad"
//系统版本
var osVersion:Double=8.0

@available(iOS 8.0, *)
class RootViewController: UITabBarController , ChangeTableDelegate{
    
    //欢迎页的控件
    var welcome:UIViewController!
    
    //自定义的Tabbar
    var mytabBar:TabBarController!
    
    //选项的滑动件
    var menuVC:SideMenuController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone){
            deviceDefine = ""
        }
        osVersion = NSString(string: UIDevice.currentDevice().systemVersion).doubleValue
        
        //方便调用的全局变量
        rootController = self
        
        //初始化各个部分
        var home = Home.HomeRoot()
        var recipes = Recipes.RecipesInit()
        rootSideMenu = SideMenuController(nibName: nil, bundle: nil)
        rootSideMenu.rootViewController = recipes
        rootSideMenu.SideView = CategoryMenu.CategoryMenuInit()
        var ingridientController = Ingredients.IngredientsRoot()
        var userCenterController = UserHome.UserHomeRoot()
        var tabBarViewControllers = [home,rootSideMenu, ingridientController,userCenterController]
        self.setViewControllers(tabBarViewControllers, animated: false)
        
        //处理的自定义Toolbar
        self.tabBar.hidden = true;
        mytabBar = TabBarController.TabBarControllerInit()
        mytabBar.delegate = self
        mytabBar.view.frame = CGRect(x: 0, y: self.view.frame.size.height - 50 , width: self.view.frame.size.width, height: 50)
        self.view.addSubview(mytabBar.view)
        //判断是否是第一次运行，如果是就调出欢迎界面
        if(!NSUserDefaults.standardUserDefaults().boolForKey("Launched_V1.0.0")){
            //在文档中默认加一个用户头像
            var image = UIImage(named: "headDefault")
            var imageData = UIImagePNGRepresentation(image!)
            imageData!.writeToFile(applicationDocumentsPath+"/myimage.png", atomically: false)
            
            //设置一些基础的数据
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "Launched_V1.0.0")
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "UserCook")
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "UserFavor")
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "UserHave")
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "UserContainer")
            NSUserDefaults.standardUserDefaults().setObject("cocoPad", forKey: "UserName")
            welcome = WelcomePlus.WelcomePlusInit()
            self.view.addSubview(welcome.view)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad && osVersion<8){//iPad,IOS7的bug
            mytabBar.view.frame = CGRect(x: 0, y: self.view.frame.size.width - 50 , width: self.view.frame.size.height, height: 50)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //@MARK:控制下端Toolbar的代码
    var toolbarHidden:Bool=true
    //显示或影藏工具栏
    func showOrhideToolbar(opt:Bool){
        
        if(toolbarHidden != opt){
            toolbarHidden=opt
            if(opt){//显示
                self.mytabBar.view.hidden = false
                UIView.animateWithDuration(0.3, animations: {
                    if(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad && osVersion<8){
                        self.mytabBar.view.frame = CGRect(x: 0, y: self.view.frame.size.width - 50 , width: self.view.frame.size.height, height: 50)
                    }else{
                        self.mytabBar.view.frame = CGRect(x: 0, y: self.view.frame.size.height - 50 , width: self.view.frame.size.width, height: 50)
                    }
                })
            }else{//隐藏
                UIView.animateWithDuration(0.3, animations: {
                    if(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad && osVersion<8){
                        self.mytabBar.view.frame = CGRect(x: 0, y: self.view.frame.size.width, width: self.view.frame.size.height, height: 50)
                    }else{
                        self.mytabBar.view.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 50)
                    }
                }, completion: { _ in
                    self.mytabBar.view.hidden = true
                })
            }
            
        }
        
    }
    
    //@MARK:点击下端的按钮时的反馈调用
    func changeIndex(index: Int) {
        
        switch(index)
        {
        case 1:
            if(self.selectedIndex == index){
                var curent = self.selectedViewController! as! SideMenuController
                var item:UIViewController = (curent.rootViewController as! UINavigationController).topViewController!
                if(item.isKindOfClass(Recipes) == true){
                    (item as! Recipes).scrollToTop()
                }
            }
            break
        case 4:
            var moreViewController = Device.DeviceRoot()
            moreViewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
            self.view.window?.rootViewController?.presentViewController(moreViewController, animated: false, completion: nil)
        default:
            break
            
        }
        self.selectedIndex = index
    }
    
}
