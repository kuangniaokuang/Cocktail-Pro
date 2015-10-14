//
//  HomeDirectionsSync.swift
//  smartmixer
//
//  Created by 姚俊光 on 14/10/8.
//  Copyright (c) 2014年 smarthito. All rights reserved.
//

import UIKit

/**
*  该类是用于处理获取主页更新信息的网络处理部分，
*  该部分的工作首先获取一个当前服务器的版本号与本地匹配，
*  若本地版本与服务器不一致都进行下载更新
*/

//自定义一个搜索设置完毕开始搜索的消息
@available(iOS 8.0, *)
protocol HomeDirectionSyncDelegate:NSObjectProtocol{
    func homeDirectionSync(sender:HomeDirectionSync,NeedRefresh refresh:Bool)
}

@available(iOS 8.0, *)
class HomeDirectionSync {
    
    init(){
    }
    
    //代理
    var delegate:HomeDirectionSyncDelegate!
    
    //主页数据存储的基地址
    let baseUrl:String="http://???????/cocktailpro/homedirections/"
    
    //是否是强制更新
    var byForce:Bool = false
    //子线程的数量
    var subthread:Int=0
    
    //更新数据的调用
    func UpdateHomeSync(){
        //第一种 新建线程
        NSThread.detachNewThreadSelector("getServerVersionSync:", toTarget:self,withObject:self)
    }
    @objc func getServerVersionSync(sender:AnyObject){
        var owner = sender as! HomeDirectionSync
        var request = HTTPTask()
        request.GET(owner.baseUrl+"version.txt", parameters: nil, success: {(response: HTTPResponse) in
            if response.responseObject != nil {
                var localVersion:String?=NSUserDefaults.standardUserDefaults().stringForKey("HomeDirection")
                if(localVersion==nil){
                    localVersion=""
                }
                let data = response.responseObject as! NSData
                let remoteVersion = NSString(data: data, encoding: NSUTF8StringEncoding)
                if(localVersion != remoteVersion || owner.byForce){//两地的版本字符串不匹配或是强制更新，开始下载新的
                    let fileManager = NSFileManager.defaultManager()
                    var isDir:ObjCBool=false
                    if !fileManager.fileExistsAtPath(applicationDocumentsPath + "/homedirections/",isDirectory: &isDir) {
                        do{
                            try fileManager.createDirectoryAtPath(applicationDocumentsPath + "/homedirections/", withIntermediateDirectories: true, attributes: nil)
                        }catch{
                            
                        }
                    }
                    NSUserDefaults.standardUserDefaults().setObject(remoteVersion, forKey: "HomeDirection")
                    
                    self.getLatestSync(owner)
                }else{
                    if(owner.delegate != nil){
                        owner.delegate.homeDirectionSync(owner, NeedRefresh: false)
                    }
                }
            }
        },failure: {(error: NSError, response: HTTPResponse?) in
            if(owner.delegate != nil){
                owner.delegate.homeDirectionSync(owner, NeedRefresh: false)
            }
        })
    }
    
    //获取最新的文件
    func getLatestSync(sender:HomeDirectionSync){
        var request = HTTPTask()
        request.download(sender.baseUrl+"latest.zip", parameters: nil, progress: {(complete: Double) in
            }, success: {(response: HTTPResponse) in
                if response.responseObject != nil {
                    //数据下载成功，将数据解压到用户牡蛎中
                    var zip = ZipArchive()
                    zip.UnzipOpenFile((response.responseObject! as! NSURL).path)
                    needRefresh=zip.UnzipFileTo(applicationDocumentsPath+"/homedirections/", overWrite: true)
                    if(needRefresh && sender.delegate != nil){//唯一的操作成功的返回
                        sender.delegate.homeDirectionSync(sender, NeedRefresh: true)
                        return
                    }
                }
                
                if(sender.delegate != nil){
                    sender.delegate.homeDirectionSync(sender, NeedRefresh: false)
                }
                
            } ,failure: {(error: NSError, response: HTTPResponse?) in
                if(sender.delegate != nil){
                    sender.delegate.homeDirectionSync(sender, NeedRefresh: false)
                }
        })
    }
    /*
    //分析文件，开始下载数据信息
    func analysisDescription(tmpUrl:NSURL,MainThread sender:HomeDirectionSync){
        let jsonData = NSData(contentsOfURL: tmpUrl)
        let rootDescription = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        let version:NSString = rootDescription["version"] as NSString
        NSUserDefaults.standardUserDefaults().setObject(version, forKey: "HomeDirection")
        let databody:NSArray = rootDescription["data"] as NSArray
        sender.subthread = databody.count
        for item in databody {
            var str=item["image"] as String
            if(str != ""){
                getImageSync(str,MainThread:sender)
            }else{
                sender.subthread--
            }
        }
    }
    
    //异步下载图片信息
    func getImageSync(image:String,MainThread sender:HomeDirectionSync){
        var request = HTTPTask()
        request.download(sender.baseUrl+image, parameters: nil, progress: {(complete: Double) in
            }, success: {(response: HTTPResponse) in
                if response.responseObject != nil {
                    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                    let newPath = NSURL(fileURLWithPath:applicationDocumentsPath+"/homedirections/"+image)
                    NSLog("\(newPath)")
                    let fileManager = NSFileManager.defaultManager()
                    fileManager.removeItemAtURL(newPath!, error: nil)
                    var error:NSError?=nil
                    if !fileManager.moveItemAtURL(response.responseObject! as NSURL, toURL: newPath!, error: &error) {
                        NSLog(error!.localizedDescription)
                    }
                    sender.subthread--
                    if(sender.subthread==0 && sender.delegate != nil){
                        sender.delegate.homeDirectionSync(sender, NeedRefresh: true)
                    }
                }
            } ,failure: {(error: NSError) in
                if(sender.delegate != nil){
                    sender.delegate.homeDirectionSync(sender, NeedRefresh: false)
                }
        })
    }
    */
}
