//
//  AboutDetail.swift
//  smartmixer
//
//  Created by 姚俊光 on 14-9-3.
//  Copyright (c) 2014年 Smart Group. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
class AboutDetail: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var about:UIView!
    @IBOutlet var buy:UIView!
    @IBOutlet var contact:UIView!
    @IBOutlet var response:UIView!
    @IBOutlet var terms:UIView!
    
    @IBOutlet var navTitle:UINavigationItem!
    
    @IBOutlet var responseText:UITextField!
    
    @IBOutlet var responseTip:UILabel!
    
    @IBOutlet var responseEditView:UIView!
    
    var currentTag:Int = 0
    
    class func AboutDetailInit()->AboutDetail{
       var aboutDetail = UIStoryboard(name: "UserCenter"+deviceDefine, bundle: nil).instantiateViewControllerWithIdentifier("aboutDetail") as! AboutDetail
        return aboutDetail
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //添加向右滑动返回
        var slideback = UISwipeGestureRecognizer()
        slideback.addTarget(self, action: "SwipeToBack:")
        slideback.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(slideback)
        self.view.userInteractionEnabled = true
        switch currentTag{
        case 0:
            self.about.hidden = false
        case 1:
            self.contact.hidden = false
        case 3:
            self.response.hidden = false
        case 4:
            self.terms.hidden = false
        default:
            break
        }
    }
    
    func SwipeToBack(sender:UISwipeGestureRecognizer){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func showTag(tag:Int){
        currentTag = tag
        switch tag{
        case 0:
            self.about.hidden = false
            self.view.bringSubviewToFront(about)
        case 1:
            self.contact.hidden = false
            self.view.bringSubviewToFront(contact)
        case 3:
            self.response.hidden = false
            self.view.bringSubviewToFront(response)
        case 4:
            self.terms.hidden = false
            self.view.bringSubviewToFront(terms)
            
        default:
            break
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        var ex:CGFloat=250
        if(deviceDefine != ""){
            ex=400
        }
        UIView.animateWithDuration(0.2, animations: {
            self.responseEditView.frame = CGRect(x: self.responseEditView.frame.origin.x, y: self.responseEditView.frame.origin.y-ex, width: self.responseEditView.frame.width, height: self.responseEditView.frame.height)
            self.view.layoutIfNeeded()
        })
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        var ex:CGFloat=250
        if(deviceDefine != ""){
            ex=400
        }
        UIView.animateWithDuration(0.2, animations: {
            self.responseEditView.frame = CGRect(x: self.responseEditView.frame.origin.x, y: self.responseEditView.frame.origin.y+ex, width: self.responseEditView.frame.width, height: self.responseEditView.frame.height)
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func sendResponse(sender:UIButton){
        if(responseText.text != ""){
            responseText.resignFirstResponder()
            responseTip.text="谢谢您的反馈！我们将尽快处理"
            var alert = UIAlertView(title: "提示", message: "谢谢您的反馈！我们将尽快处理！",delegate: nil, cancelButtonTitle: "确定")
            alert.show()
            var request = HTTPTask()
            var params = [String:String]()
            params["response"] = responseText.text
            params["keyword"] = "nicaiyahehe"
            request.GET("http://www.smarthito.com/app/feedback.action", parameters:params, success: {(response: HTTPResponse) in
                if response.responseObject != nil {
                    var data : NSDictionary!
                    do{
                        data = try NSJSONSerialization.JSONObjectWithData(response.responseObject as! NSData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    }catch{
                        
                    }
                    NSLog((data["keyword"] as! String))
                    self.responseText.text=""
                }
            },failure: {(error: NSError, response: HTTPResponse?) in
                    
            })
        }else{
            var alert = UIAlertView(title: "提示", message: "是不是该先写点什么呀？",delegate: nil, cancelButtonTitle: "确定")
            alert.show()
        }
        
    }
    
    
    //新浪微博
    @IBAction func openWeibo(sender:UIButton){
        //http://weibo.com/u/1278678934
        //http://weibo.com/u/1149960291 我的
        UIApplication.sharedApplication().openURL(NSURL(string: "sinaweibo://userinfo?uid=1149960291")!)
    }
    //微信 weixin://qr/%@
    @IBAction func openWeixin(sender:UIButton){
        //
        UIApplication.sharedApplication().openURL(NSURL(string: "sinaweibo://userinfo?uid=1149960291")!)
        //UIApplication.sharedApplication().openURL(NSURL(string:"http://www.smarthito.com/snscontacts?to=weixin")!)
    }
    
    //陌陌 weixin://qr/%@
    @IBAction func openMomo(sender:UIButton){
        //
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.smarthito.com/snscontacts?to=momo")!)
    }
    
    //淘宝 weixin://qr/%@
    @IBAction func openTaobao(sender:UIButton){
        //
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.smarthito.com/store?to=taobao")!)
    }
    
    //微店 weixin://qr/%@
    @IBAction func openWeidian(sender:UIButton){
        //
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.smarthito.com/store?to=weidian")!)
    }
}
