//
//  RecipeDetailController.swift
//  smartmixer
//
//  Created by Koulin Yuan on 8/23/14.
//  Copyright (c) 2014 Smart Group. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 8.0, *)
class RecipeDetailPad : UIViewController {
    
    var CurrentData:Recipe!
    
    //大图
    @IBOutlet var image:UIImageView?
    
    //名字
    @IBOutlet var name:UILabel?
    
    //英文名字
    @IBOutlet var nameEng:UILabel?
    
    //是否收藏
    @IBOutlet var faver:UIImageView?
    
    //描述
    @IBOutlet var desc:UITextView?
    
    //口感
    @IBOutlet var taste:UILabel?
    
    //技巧
    @IBOutlet var skill:UILabel?
    
    //时间段
    @IBOutlet var drinkTime:UILabel?
    
    //卡路里
    @IBOutlet var calorie:UILabel!
    
    //覆盖度
    @IBOutlet var coverd:UILabel!
    
    //酒精度
    @IBOutlet var alcohol:UILabel?
    
    //描述的高度
    @IBOutlet var hDesc: NSLayoutConstraint?
    
    //主框架的高度
    @IBOutlet var hMainboard: NSLayoutConstraint?
    
    //主框架
    @IBOutlet var parentView:UIView?
    
    //难度
    @IBOutlet var difficulty:UILabel?
    
    @IBOutlet var navTitle:UINavigationItem!
    
    @IBOutlet var showBt:UIButton!
    
    //显示详细的窗口
    var popview:PopupView! = nil
    
    var moresize:CGFloat = 0
    
    class func RecipeDetailPadInit()->RecipeDetailPad{
        var recipeDetail = UIStoryboard(name: "Recipes"+deviceDefine, bundle: nil).instantiateViewControllerWithIdentifier("recipeDetail") as! RecipeDetailPad
        return recipeDetail
    }
    
    
    override func viewDidLoad() {
        rootController.showOrhideToolbar(false)
        super.viewDidLoad()
        var left = UIBarButtonItem(title: "开始制作", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("toCook:"))
        self.navigationItem.rightBarButtonItem = left
        if(CurrentData != nil){
            self.image?.image = UIImage(named: CurrentData.thumb)
            self.name?.text = "\(CurrentData.name)"
            if(navTitle != nil){
                navTitle.title = "\(CurrentData.name)"
            }
            self.nameEng?.text = "\(CurrentData.nameEng)"
            if(CurrentData.isfavorite == true){
                self.faver?.image = UIImage(named: "Heartyes.png")
            }else{
                self.faver?.image = UIImage(named: "Heartno.png")
            }
            var size = CurrentData.des.textSizeWithFont(self.desc!.font!, constrainedToSize: CGSize(width:314, height:1000))
            if(size.height<146){
                showBt.hidden = true
            }
            self.desc?.text = CurrentData.des
            if(CurrentData.taste.integerValue == 0){
                self.taste?.text = "甜味"
            }else if(CurrentData.taste.integerValue == 1){
                self.taste?.text = "中味"
            }else if(CurrentData.taste.integerValue == 2){
                self.taste?.text = "辣味"
            }
            if(CurrentData.skill.integerValue == 0){
                self.skill?.text = "兑和"
            }else if(CurrentData.skill.integerValue == 1){
                self.skill?.text = "摇和"
            }else if(CurrentData.skill.integerValue == 2){
                self.skill?.text = "调和"
            }else if(CurrentData.skill.integerValue == 3){
                self.skill?.text = "搅和"
            }else{
                self.skill?.text = "漂浮"
            }
            if(CurrentData.drinktime.integerValue == 0){
                self.drinkTime?.text = "餐前"
            }else if(CurrentData.drinktime.integerValue == 1){
                self.drinkTime?.text = "餐后"
            }else if(CurrentData.drinktime.integerValue == 2){
                self.drinkTime?.text = "全天"
            }
            self.alcohol?.text = "\(CurrentData.alcohol)°"
            self.difficulty?.text = CurrentData.difficulty.stringValue
            self.calorie.text = "\(CurrentData.calorie) 卡"
            self.coverd.text = String(format:"%.0f", CurrentData.coverd.doubleValue*100)+"%"
        }
        if(popview == nil){
            popview = PopupView(frame:CGRect(x: 200, y: 100, width: 600, height: 500))
            popview?.parentView = self.view
            popview?.hidden = true
            popview.arrorDirection = ArrorDirection.right
            self.view.addSubview(popview!)
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    var recipeIngridients:RecipeIngridients!=nil
    
    //显示材料信息
    @IBAction func showIngridient(sender:UIButton){
        if(popview.hidden == true){
            if(recipeIngridients == nil){
                recipeIngridients = UIStoryboard(name: "Recipes_ipad", bundle: nil).instantiateViewControllerWithIdentifier("recipeIngridients") as! RecipeIngridients
                recipeIngridients.recipeId = CurrentData.id.integerValue
            }
            if(popview?.currentView != recipeIngridients.view){
                recipeIngridients.view.frame = CGRect(origin: CGPoint(), size: recipeIngridients.ViewSize)
            }
            popview?.showNewView(recipeIngridients.view, pointToItem: sender)
        }else {
            popview.closeView(sender)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func ShowAllTextPad(sender:UIButton){
        if(hMainboard?.constant == 520){
            var str:String = desc!.text!
            var size = str.textSizeWithFont(desc!.font!, constrainedToSize: CGSize(width:314, height:1000))
            if(size.height > (hDesc!.constant-28)){
                UIView.animateWithDuration(0.4, animations: {
                    self.hMainboard!.constant = 354 + size.height;
                    self.hDesc!.constant = size.height + 28;
                    self.parentView!.layoutIfNeeded();
                    }, completion: { _ in
                        sender.titleLabel!.text = "《收起";
                })
            }
        }else{
            UIView.animateWithDuration(0.4, animations: {
                self.hMainboard!.constant = 520
                self.hDesc!.constant = 166
                self.parentView!.layoutIfNeeded()
                }, completion: { _ in
                    sender.titleLabel!.text = "全部》"
            })
        }
        
    }
    
    @IBAction func clickFaver(sender:UIButton){
        CurrentData.isfavorite = !CurrentData.isfavorite.boolValue
        if(CurrentData.isfavorite == true){
            self.faver?.image = UIImage(named: "Heartyes.png")
            UserHome.addHistory(1, id: CurrentData.id.integerValue, thumb: CurrentData.thumb, name: CurrentData.name)
        }else{
            self.faver?.image = UIImage(named: "Heartno.png")
            UserHome.removeHistory(1, id: CurrentData.id.integerValue)
        }
        do{
            try managedObjectContext.save()
        }catch{
            abort()
        }
    }
    
    @IBAction func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //点击去制作
    @IBAction func toCook(sender:UIButton){
    }
}

