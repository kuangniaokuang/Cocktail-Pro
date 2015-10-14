//
//  TabBarViewController.swift
//  smartmixer
//
//  Created by kingzhang on 8/24/14.
//  Copyright (c) 2014 Smart Group. All rights reserved.
//

import UIKit

protocol ChangeTableDelegate{
    func changeIndex ( index: Int)
}

@available(iOS 8.0, *)
class TabBarController: UIViewController {
    //
    @IBOutlet  var  senceButton : UIButton!
    @IBOutlet  var  recipeButton : UIButton!
    @IBOutlet  var  ingredientButton : UIButton!
    @IBOutlet  var  homeButton : UIButton!
    @IBOutlet  var  deviceButton : UIButton!
    
    var currentSelected:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(osVersion<8){
            self.view.backgroundColor = UIColor(white: 1, alpha: 0.88)
        }else{
            let blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))
            blur.frame = self.view.frame
            self.view.addSubview(blur)
            self.view.sendSubviewToBack(blur)
        }
        
        currentSelected = senceButton
        senceButton.setImage(UIImage(named: "recipe_on.png"), forState: UIControlState.Selected)
        recipeButton.setImage(UIImage(named: "ingridient_on.png"), forState: UIControlState.Selected)
        ingredientButton.setImage(UIImage(named: "container_on.png"), forState: UIControlState.Selected)
        homeButton.setImage(UIImage(named: "user_on.png"), forState: UIControlState.Selected)
        
        //设置阴影颜色，透明度，偏移量
        self.view.layer.shadowColor = UIColor.grayColor().CGColor
        self.view.layer.shadowRadius = 2
        self.view.layer.shadowOpacity = 0.35;
        self.view.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    }
    
    class func TabBarControllerInit()->TabBarController{
        var tabBarController = UIStoryboard(name:"Main"+deviceDefine,bundle:nil).instantiateViewControllerWithIdentifier("tabBarController") as! TabBarController
        return tabBarController
    }
    
    //
    var delegate : ChangeTableDelegate?
    
    @IBAction func changeTabBar(sender : UIButton)
    {
        if(sender.tag < 4){
            currentSelected.selected = false
            if(sender.tag == 0){
                currentSelected = senceButton
            } else if(sender.tag == 1){
                currentSelected = recipeButton
            } else if(sender.tag == 2){
                currentSelected = ingredientButton
            } else if(sender.tag == 3){
                currentSelected = homeButton
            }
            currentSelected.selected = true
        }
        delegate?.changeIndex(sender.tag)
    }
}
