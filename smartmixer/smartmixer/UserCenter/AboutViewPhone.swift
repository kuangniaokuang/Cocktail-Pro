//
//  AboutViewPhone.swift
//  smartmixer
//
//  Created by 姚俊光 on 14-9-9.
//  Copyright (c) 2014年 Smart Group. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
class AboutViewPhone: UITableViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate{
    
    //头像图片
    @IBOutlet var headImage:UIImageView!
    //名字
    @IBOutlet var userName:UILabel!
    
    var delegate:NumberDelegate!
    
    class func AboutViewPhoneInit()->AboutViewPhone{
        var aboutview = UIStoryboard(name: "UserCenter"+deviceDefine, bundle: nil).instantiateViewControllerWithIdentifier("aboutView") as! AboutViewPhone
        return aboutview
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        headImage.image = UIImage(contentsOfFile: applicationDocumentsPath+"/myimage.png")
        userName.text = NSUserDefaults.standardUserDefaults().stringForKey("UserName")!
    }
    
    func gotoMark(){
        UIApplication.sharedApplication().openURL(NSURL(string: itunesLink)!)
    }
    
    @IBAction func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        rootController.showOrhideToolbar(true)
    }
    
    //欢迎页面
    var welcome:WelcomePlus!
    //选取照片
    var imagePicker:UIImagePickerController!
    var popview:UIPopoverController!
    var usernewName:String!
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.section==0 && indexPath.row==0){//点击更换头像
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
            imagePicker.allowsEditing = true
            if(deviceDefine==""){
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }else{
                popview = UIPopoverController(contentViewController: imagePicker)
                popview.presentPopoverFromRect(CGRect(x: 145, y: 90, width: 10, height: 10), inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
            }
        }else if(indexPath.section==0 && indexPath.row==1){//点击修改名字
            
            if(osVersion<8){
                var alert = UIAlertView(title: "编辑昵称", message: nil, delegate: self, cancelButtonTitle: "取消")
                alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
                alert.textFieldAtIndex(0)?.text = self.userName.text
                alert.addButtonWithTitle("确定")
                alert.show()
            }else{
                var alert = UIAlertController(title: "编辑昵称", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addTextFieldWithConfigurationHandler { (choiceNameTF) -> Void in
                    choiceNameTF.borderStyle = .None
                    choiceNameTF.text = NSUserDefaults.standardUserDefaults().stringForKey("UserName")!
                    choiceNameTF.placeholder = "输入你的昵称"
                    choiceNameTF.delegate = self
                    choiceNameTF.becomeFirstResponder()
                }
                alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler:nil))
                alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler:{ (action) -> Void in
                    NSUserDefaults.standardUserDefaults().setObject(self.usernewName, forKey: "UserName")
                    self.userName.text=self.usernewName
                    }
                    ))
                self.view.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            }
            
        }else if(indexPath.row==2){
            gotoMark()
        }else if(indexPath.row==5){
            welcome = WelcomePlus.WelcomePlusInit()
            welcome.firstPop=false;
            welcome.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
            self.view.window?.rootViewController?.presentViewController(welcome, animated: true, completion: nil)
        }else{
            if(deviceDefine==""){
                var aboutDetail = AboutDetail.AboutDetailInit()
                aboutDetail.currentTag = indexPath.row
                self.navigationController?.pushViewController(aboutDetail, animated: true)
            }else if(self.delegate != nil){
                self.delegate.NumberAction(self, num: indexPath.row)
            }
        }
    }
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        var title = alertView.buttonTitleAtIndex(buttonIndex)
        if(title=="确定"){
            self.userName.text=alertView.textFieldAtIndex(0)?.text
            NSUserDefaults.standardUserDefaults().setObject(self.userName.text, forKey: "UserName")
            
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        usernewName = textField.text
    }
    
    //写入Document中
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var image = info["UIImagePickerControllerEditedImage"] as! UIImage
        headImage.image = image
        var imageData = UIImagePNGRepresentation(image)
        imageData!.writeToFile(applicationDocumentsPath+"/myimage.png", atomically: false)
        self.dismissViewControllerAnimated(true, completion: nil)
        if(osVersion<8 && deviceDefine != ""){
            popview.dismissPopoverAnimated(true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
