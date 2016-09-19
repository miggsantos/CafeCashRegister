//
//  productsWS.swift
//  CafeCashRegister
//
//  Created by Miguel Santos on 15/05/16.
//  Copyright © 2016 Miguel Santos. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataService {
    static let instance = DataService()
    
    var tempTypes = [String]()
    var tempItems = [[String:AnyObject]]()
    
    
    var backgroundThreadContext:NSManagedObjectContext?;
    
    
    func getBackThreadContext() -> NSManagedObjectContext{
        
        if backgroundThreadContext == nil{
        
            let mainContext = appDelegate.managedObjectContext
            
            backgroundThreadContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
            backgroundThreadContext!.persistentStoreCoordinator = mainContext.persistentStoreCoordinator
            
        }
        
        return backgroundThreadContext!
    
    }
    
    func updateProgress(current:Int){
        
        dispatch_async(dispatch_get_main_queue(), {
            let progressData = [ "total": self.tempItems.count, "current":current]
            
            NSNotificationCenter.defaultCenter().postNotificationName("updateProgress", object: progressData)
        })
        

    }
    
    func processOnlineData() -> (dataExists:Bool, typeCount:Int, itemsCount: Int){
        
        var dataExists = false
        var typeCount = 0
        var itemsCount = 0
        
        
        guard let url = defaults.stringForKey(RemoteDataKeys.dataUrl) where url != "" else {
            return (dataExists, typeCount , itemsCount)
        }
        
        guard let data = getJSON(url) as NSData! else {
            return (dataExists, typeCount , itemsCount)
        }

        print("getTypes")
        getTypes(data)
        print("getProducts")
        getProducts(data)
  
        dataExists = true
        typeCount = tempTypes.count
        itemsCount = tempItems.count
        
        return (dataExists, typeCount , itemsCount)
    
    }
    
    func insertOnlineData(){
        

        
            print("removeTypes")
            removeTypes()
            print("removeProducts")
            removeProducts()
            

            print("insertTypes")
            insertTypes()
        
            print("insertProducts")
            self.insertProducts()

            
            print("done!")
            

        
    }
    
    //MARK: Remove
    
    func removeProducts(){

        let context = getBackThreadContext()
        let fetchRequest = NSFetchRequest(entityName: "Item")
        
        do{
            let result = try context.executeFetchRequest(fetchRequest)
            
            if let items = result as? [Item] {
                
                for item in items {
                    context.deleteObject(item)
                }
            }
            
            
        } catch let err as NSError {
            print(err.debugDescription)
            return
        }
    }
    
    func removeTypes(){

        let context = getBackThreadContext()
        let fetchRequest = NSFetchRequest(entityName: "ItemType")
        
        do{
            let result = try context.executeFetchRequest(fetchRequest)
            
            if let types = result as? [ItemType] {
                
                for type in types {
                    context.deleteObject(type)
                }
            }
            
            
        } catch let err as NSError {
            print(err.debugDescription)
            return
        }
        
    }
    
    //MARK: Insert
    
    func insertProducts(){

        let context = getBackThreadContext()

        context.performBlock { // runs asynchronously
            
            autoreleasepool {
                
                
                print("items count = \(self.tempTypes.count)")
                
                var i:Int = 1
                for item in self.tempItems {
                    

                    self.updateProgress(i)

                    
                    let obj = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: context) as! Item
                    
                    let name = item["name"]
                    let price = item["price"]
                    let type = item["type"]
                    
                    if let name = name as? String, let price = price as? Double, let type = type as? String {

                        let itemType = self.fetchItemType(type)
                        if let itemType = itemType {
                        
                            obj.setValues(name, price: NSNumber.init(double: price), itemType: itemType )
                            
                            if let imgUrl = item["url"] as? String where imgUrl != "" {
                                
                                let url = NSURL(string: imgUrl)
                                if let data = NSData(contentsOfURL: url!) {
                                    obj.setItemImage( UIImage(data: data)! )
                                } else {
                                    print("Erro: \(url)")
                                }
                            }
                        
                        }
                    }
                    i+=1
                    
                    
                }
                
            }
            
            // only save once per batch insert
            do {
                try context.save()
            } catch {
                print(error)
            }
            
            context.reset()
        }
    }
    
    func fetchItemType(type:String?) -> ItemType?{
        
        let context = getBackThreadContext()
        let fetchRequest = NSFetchRequest(entityName: "ItemType")
        
        if let typeName = type {
            let predicate = NSPredicate(format: "type = %@", typeName )
            fetchRequest.predicate = predicate
        }
        
        do{
            let result = try context.executeFetchRequest(fetchRequest)
            return result[0] as? ItemType
        } catch let err as NSError {
            print(err.debugDescription)
            return nil
        }
    }
    
    func insertTypes(){
        
        let context = getBackThreadContext()
        context.performBlock { // runs asynchronously
            
            autoreleasepool {
                
                for type in self.tempTypes {
                    let obj = NSEntityDescription.insertNewObjectForEntityForName("ItemType", inManagedObjectContext: context) as! ItemType
                    obj.setValues(type)
                }
            }
            
            // only save once per batch insert
            do {
                try context.save()
            } catch {
                print(error)
            }
            
            context.reset()
        }
        
        
    }
    
    //MARK: get data from json
    
    func getProducts(data:NSData) {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            
            if let items = json["items"] as? [[String: AnyObject]] {
                tempItems = items
            }
        } catch {
            print("getProducts - error serializing JSON: \(error)")
        }
    }
    
    
    func getTypes(data:NSData) {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            
            if let types = json["types"] as? [String] {
                tempTypes = types
            }
        } catch {
            print("getTypes - error serializing JSON: \(error)")
        }
    }
    
    //MARK: get JSON from url
    
    func getJSON(urlToRequest: String) -> NSData?{
        return NSData(contentsOfURL: NSURL(string: urlToRequest)!)
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
}

