//
//  PhoneWeb.swift
//  smartmixer
//
//  Created by 姚俊光 on 14/10/1.
//  Copyright (c) 2014年 smarthito. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
class WebView: UIViewController,UIWebViewDelegate{
    
    //网页的控件
    @IBOutlet var webPage:UIWebView!
    
    //显示的标题
    @IBOutlet var webTitle:UINavigationItem!
    
    @IBOutlet var tipLable:UILabel!
    
    //显示的标题
    var strWebTitle:String!="Smart Hito"
    
    //需要显示的网页链接
    var WebUrl:String!
    
    var showToolbar:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var right = UIBarButtonItem(image: UIImage(named: "refresh"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("refresh:"))
        self.navigationItem.rightBarButtonItem = right
        
        if(osVersion<8){//新版
            webPage.frame = CGRect(x: 0, y: -64, width: self.view.frame.width, height: self.view.frame.height-64)
            self.view.layoutIfNeeded()
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        webTitle.title = strWebTitle
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        var request = NSURLRequest(URL: NSURL(string: WebUrl)!)
        webPage.loadRequest(request)
    }
    //返回一个初始化
    class func WebViewInit()-> WebView {
        var extende = ""
        if(osVersion<8){
            extende = "7"
        }
        var webView = UIStoryboard(name: "Common"+deviceDefine, bundle: nil).instantiateViewControllerWithIdentifier("webView"+extende) as! WebView
        return webView
    }
    
    /**
    刷新页面
    
    :param: sender <#sender description#>
    */
    func refresh(sender:UINavigationItem){
        webPage.reload()
    }
    
    //网页加载中
    func webViewDidStartLoad(webView: UIWebView) {
        tipLable.hidden=false
    }
    //网页加载完毕
    func webViewDidFinishLoad(webView: UIWebView) {
        tipLable.hidden=true
    }
    
    //返回
    @IBAction func goback(sender:UINavigationItem){
        self.navigationController?.popViewControllerAnimated(true)
        if(showToolbar){
            rootController.showOrhideToolbar(true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
