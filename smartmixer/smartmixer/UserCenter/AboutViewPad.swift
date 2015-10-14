//
//  AboutViewPad.swift
//  smartmixer
//
//  Created by 姚俊光 on 14/10/15.
//  Copyright (c) 2014年 smarthito. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
class AboutViewPad: UIViewController ,NumberDelegate {

    var aboutTable:AboutViewPhone!
    
    var aboutDetail:AboutDetail!
    
    class func AboutViewPadInit()->AboutViewPad{
        var aboutview = UIStoryboard(name: "UserCenter"+deviceDefine, bundle: nil).instantiateViewControllerWithIdentifier("aboutViewPad") as! AboutViewPad
        return aboutview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        aboutDetail = AboutDetail.AboutDetailInit()
        aboutDetail.view.frame = CGRect(x: 300, y: 64, width: self.view.frame.width-300, height: self.view.frame.height-64)
        self.view.addSubview(aboutDetail.view)
        aboutTable = AboutViewPhone.AboutViewPhoneInit()
        aboutTable.delegate = self
        NSLog("\(self.view.frame)")
        if(osVersion<8){
            aboutTable.view.frame = CGRect(x: 0, y: 64, width: 50, height: self.view.frame.height-64)
        }else{
            aboutTable.view.frame = CGRect(x: 0, y: 64, width: 300, height: self.view.frame.height-64)
        }
        self.view.addSubview(aboutTable.view)
    }

    func NumberAction(sender:UIViewController,num Number:Int){
        aboutDetail.showTag(Number)
    }
    
    @IBAction func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        rootController.showOrhideToolbar(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
