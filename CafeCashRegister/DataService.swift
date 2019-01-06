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
            
            backgroundThreadContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            backgroundThreadContext!.persistentStoreCoordinator = mainContext.persistentStoreCoordinator
            
        }
        
        return backgroundThreadContext!
    
    }
    
    func updateProgress(_ current:Int){
        
        DispatchQueue.main.async(execute: {
            let progressData = [ "total": self.tempItems.count, "current":current]
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "updateProgress"), object: progressData)
        })
        

    }
    
    func processOnlineData() -> (dataExists:Bool, typeCount:Int, itemsCount: Int){
        
        var dataExists = false
        var typeCount = 0
        var itemsCount = 0
        
        
        guard let url = defaults.string(forKey: RemoteDataKeys.dataUrl), url != "" else {
            return (dataExists, typeCount , itemsCount)
        }
        
        guard let data = getJSON(url) as Data! else {
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        
        do{
            let result = try context.fetch(fetchRequest)
            
            if let items = result as? [Item] {
                
                for item in items {
                    context.delete(item)
                }
            }
            
            
        } catch let err as NSError {
            print(err.debugDescription)
            return
        }
    }
    
    func removeTypes(){

        let context = getBackThreadContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemType")
        
        do{
            let result = try context.fetch(fetchRequest)
            
            if let types = result as? [ItemType] {
                
                for type in types {
                    context.delete(type)
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

        context.perform { // runs asynchronously
            
            autoreleasepool {
                
                
                print("items count = \(self.tempTypes.count)")
                
                var i:Int = 1
                for item in self.tempItems {
                    

                    self.updateProgress(i)

                    
                    let obj = NSEntityDescription.insertNewObject(forEntityName: "Item", into: context) as! Item
                    
                    let name = item["name"]
                    let price = item["price"]
                    let type = item["type"]
                    
                    if let name = name as? String, let price = price as? Double, let type = type as? String {

                        let itemType = self.fetchItemType(type)
                        if let itemType = itemType {
                        
                            obj.setValues(name, price: NSNumber.init(value: price as Double), itemType: itemType )
                            
                            if let imgUrl = item["url"] as? String, imgUrl != "" {
                                
                                let url = URL(string: imgUrl)
                                if let data = try? Data(contentsOf: url!) {
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
    
    func fetchItemType(_ type:String?) -> ItemType?{
        
        let context = getBackThreadContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemType")
        
        if let typeName = type {
            let predicate = NSPredicate(format: "type = %@", typeName )
            fetchRequest.predicate = predicate
        }
        
        do{
            let result = try context.fetch(fetchRequest)
            return result[0] as? ItemType
        } catch let err as NSError {
            print(err.debugDescription)
            return nil
        }
    }
    
    func insertTypes(){
        
        let context = getBackThreadContext()
        context.perform { // runs asynchronously
            
            autoreleasepool {
                
                for type in self.tempTypes {
                    let obj = NSEntityDescription.insertNewObject(forEntityName: "ItemType", into: context) as! ItemType
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
    
    func getProducts(_ data:Data) {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
            {
                tempItems = json["items"] as! [[String : AnyObject]] 
            }
        } catch let error {
            print("getProducts - error serializing JSON: \(error)")
        }
    }
    
    
    func getTypes(_ data:Data) {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
            {
                tempTypes = json["types"] as! [String]
            }
        } catch {
            print("getTypes - error serializing JSON: \(error)")
        }
    }
    
    //MARK: get JSON from url
    
    func getJSON(_ urlToRequest: String) -> Data?{
        return (try? Data(contentsOf: URL(string: urlToRequest)!))
    }
    
    func getDataFromUrl(_ url:URLRequest, completion: @escaping ((_ data: Data?, _ response: URLResponse?, _ error: Error? ) -> Void)) {
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            completion(data, response, error)
            }) .resume()
    }
    
}

