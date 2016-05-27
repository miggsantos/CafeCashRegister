//
//  productsWS.swift
//  CafeCashRegister
//
//  Created by Miguel Santos on 15/05/16.
//  Copyright © 2016 Miguel Santos. All rights reserved.
//

import Foundation
import CoreData


var tempTypes = [String]()
var tempItems = [[String:String]]()

let ProductsDataUrl:String = "https://api.myjson.com/bins/z1jq"


func processOnlineData(){

    let data = getJSON(ProductsDataUrl) as NSData!
    
    if data != nil {
        
        print("removeTypes")
        removeTypes()
        print("removeProducts")
        removeProducts()
        
        print("getTypes")
        getTypes(data)
        print("getProducts")
        getProducts(data)
        
        print("insertTypes")
        insertTypes()
        print("insertProducts")
        insertProducts()
        
        print("done!")
    
    }

}

func removeProducts(){
    let context = appDelegate.managedObjectContext
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
    // Remove the existing items
  
    let context = appDelegate.managedObjectContext
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


func insertProducts(){
    
    let context = appDelegate.managedObjectContext
    context.performBlock { // runs asynchronously
        
        autoreleasepool {
            
            for item in tempItems {
                let obj = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: context) as! Item
                obj.setValues(item["name"]!,
                            price: NSNumber.init(double: Double.init(item["price"]!)!),
                            itemType: fetchItemType(item["type"]!)! )
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
    
    let context = appDelegate.managedObjectContext
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
    
    
    let context = appDelegate.managedObjectContext
    context.performBlock { // runs asynchronously

        autoreleasepool {
            
            for type in tempTypes {
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


func getProducts(data:NSData) {
    do {
        let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        
        if let items = json["items"] as? [[String: String]] {
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


func getJSON(urlToRequest: String) -> NSData?{
    return NSData(contentsOfURL: NSURL(string: urlToRequest)!)
}



