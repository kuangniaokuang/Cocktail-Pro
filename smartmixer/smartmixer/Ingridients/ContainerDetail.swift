//
//  ContainerDetail.swift
//  smartmixer
//
//  Created by 姚俊光 on 14-8-19.
//  Copyright (c) 2014年 Smart Group. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 8.0, *)
class ContainerDetail: UIViewController , NSFetchedResultsControllerDelegate {
    
    //绑定缩略图
    @IBOutlet var image : UIImageView!
    
    //酒器的名字
    @IBOutlet var name : UILabel!
    
    //酒器的英文名字
    @IBOutlet var nameEng : UILabel!
    
    //酒器的描述
    @IBOutlet var desc : UITextView!
    
    //酒器是否已收藏
    @IBOutlet var collected : UIImageView!
    
    //宽度
    @IBOutlet weak var hCondition: NSLayoutConstraint?
    
    @IBOutlet var navTitle:UINavigationItem!
    
    @IBOutlet var contentScroll:UIScrollView!
    
    //当前的编辑对象
    var CurrentContainer:Container!
    
    class func ContainerDetailInit()->ContainerDetail{
        var containerDetail = UIStoryboard(name:"Ingredients"+deviceDefine,bundle:nil).instantiateViewControllerWithIdentifier("containerDetail") as! ContainerDetail
        return containerDetail
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(CurrentContainer != nil){
            if(navTitle != nil){
                navTitle.title = "\(CurrentContainer.name)"
            }
            name.text = "\(CurrentContainer.name)"
            nameEng.text = "\(CurrentContainer.nameEng)"
            desc.text = CurrentContainer.des
            
            if(CurrentContainer.ihave == true){
                collected.image = UIImage(named: "Heartyes.png")
            }else{
                collected.image = UIImage(named: "Heartno.png")
            }
            if(self.hCondition != nil){
                var size = CurrentContainer.name.textSizeWithFont(name.font, constrainedToSize: CGSize(width:1000, height:36))
                self.hCondition?.constant = size.width
            }
            self.image.image = UIImage(named: self.CurrentContainer.thumb)
        }
        if(deviceDefine==""){
            //添加向右滑动返回
            var slideback = UISwipeGestureRecognizer()
            slideback.addTarget(self, action: "SwipeToBack:")
            slideback.direction = UISwipeGestureRecognizerDirection.Right
            self.view.addGestureRecognizer(slideback)
            self.view.userInteractionEnabled = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if(self.contentScroll != nil){//iPhone的滚动
            var size = desc.text.textSizeWithFont(desc.font!, constrainedToSize: CGSize(width:310, height:1000))
            desc.frame = CGRect(x: desc.frame.origin.x, y: desc.frame.origin.y, width: 310, height: size.height+20)
            contentScroll.contentSize = CGSize(width: 320, height: 520+size.height)
            self.view.layoutIfNeeded()
        }
    }
    
    func SwipeToBack(sender:UISwipeGestureRecognizer){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func goback(sender : UIButton){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    var phoneWeb:WebView!
    @IBAction func tuBuy(sender: UIButton){
        phoneWeb=WebView.WebViewInit()
        self.navigationController?.pushViewController(phoneWeb, animated: true)
    }
    
    //点击收藏与取消收藏
    @IBAction func clickCollect (sender : UIButton){
        CurrentContainer.ihave = !CurrentContainer.ihave.boolValue
        if(CurrentContainer.ihave == true){
            collected.image = UIImage(named: "Heartyes.png")
            UserHome.addHistory(3, id: CurrentContainer.id.integerValue, thumb: CurrentContainer.thumb, name: CurrentContainer.name)
        }else{
            collected.image = UIImage(named: "Heartno.png")
            UserHome.removeHistory(3, id: CurrentContainer.id.integerValue)
        }
        do{
            try managedObjectContext.save()
        }catch{
            abort()
        }
        
    }
}
