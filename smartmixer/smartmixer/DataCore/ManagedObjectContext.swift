//
//  ManagedObjectContext.swift
//  smartmixer
//
//  Created by Koulin Yuan on 8/27/14.
//  Copyright (c) 2014 Smart Group. All rights reserved.
//

import Foundation
import CoreData

var applicationDocumentsDirectory: NSURL! = {
    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    return urls[urls.endIndex-1] as NSURL
    }()

//应用的Document路径
var applicationDocumentsPath:String! = {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    return paths[0] as String
    }()
var managedObjectModel: NSManagedObjectModel! = {
    let modelURL = NSBundle.mainBundle().URLForResource("smartmixer", withExtension: "momd")
    return NSManagedObjectModel(contentsOfURL: modelURL!)
    }()

var persistentStoreCoordinator: NSPersistentStoreCoordinator! = {
    var error: NSError? = nil
    /**
    var storeUrl = applicationDocumentsDirectory.URLByAppendingPathComponent("cocktailpro.sqlite")
    var _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
    if _persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeUrl, options: nil, error: &error) == nil {
    }
    return _persistentStoreCoordinator
    **/
    var storeUrl = applicationDocumentsDirectory.URLByAppendingPathComponent("cocktailpro.sqlite")
    if !NSFileManager.defaultManager().fileExistsAtPath(storeUrl.path!) {
        var preloadUrl = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("cocktailpro", ofType: "sqlite")!)
        do{
            try NSFileManager.defaultManager().copyItemAtURL(preloadUrl, toURL: storeUrl)
        }catch{
            abort()
        }
    }
    var pStore = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
    do{
        try pStore.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeUrl, options: nil)
    }catch{
        abort()
    }
    return pStore
    /* */
    }()

let managedObjectContext: NSManagedObjectContext! = {
    var context = NSManagedObjectContext()
    context.persistentStoreCoordinator = persistentStoreCoordinator
    return context
    }()


let UnitDictory:Dictionary<Int, String> = {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName("Unit", inManagedObjectContext: managedObjectContext)
    
    let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
    let sortDescriptors = [sortDescriptor]
    fetchRequest.sortDescriptors = sortDescriptors
    
    var items:[Unit]!
    do{
        items = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Unit]
    }catch{
        
    }
    
    var units = Dictionary<Int, String>()
    
    for item in items {
        units[item.id.integerValue] = item.name as String
    }
    
    return units
    }()
