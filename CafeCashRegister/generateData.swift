//
//  generateData.swift
//  CafeCashRegister
//
//  Created by Miguel Santos on 11/06/16.
//  Copyright © 2016 Miguel Santos. All rights reserved.
//

import Foundation
import CoreData

//MARK: Generate Data

func generateTestData(){
    
    let type1 = NSEntityDescription.insertNewObjectForEntityForName("ItemType", inManagedObjectContext: appDelegate.managedObjectContext) as! ItemType
    type1.setValues("Cafe")
    
    appDelegate.saveContext()
    
    let type2 = NSEntityDescription.insertNewObjectForEntityForName("ItemType", inManagedObjectContext: appDelegate.managedObjectContext) as! ItemType
    type2.setValues("Bebidas")
    
    appDelegate.saveContext()
    
    let type3 = NSEntityDescription.insertNewObjectForEntityForName("ItemType", inManagedObjectContext: appDelegate.managedObjectContext) as! ItemType
    type3.setValues("Alcool")
    
    appDelegate.saveContext()
    
    let type4 = NSEntityDescription.insertNewObjectForEntityForName("ItemType", inManagedObjectContext: appDelegate.managedObjectContext) as! ItemType
    type4.setValues("Comer")
    
    appDelegate.saveContext()
    
    
    let type5 = NSEntityDescription.insertNewObjectForEntityForName("ItemType", inManagedObjectContext: appDelegate.managedObjectContext) as! ItemType
    type5.setValues("Tabaco")
    
    
    appDelegate.saveContext()
    
    
    
    
    let item1 = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: appDelegate.managedObjectContext) as! Item
    item1.setValues("café", price: 0.55, itemType: type1)
    
    appDelegate.saveContext()
    let item2 = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: appDelegate.managedObjectContext) as! Item
    item2.setValues("descafeinado", price: 0.45, itemType: type1)
    appDelegate.saveContext()
    
    let item3 = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: appDelegate.managedObjectContext) as! Item
    item3.setValues("carioca", price: 0.55, itemType: type1)
    appDelegate.saveContext()
    
    let item4 = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: appDelegate.managedObjectContext) as! Item
    item4.setValues("cerveja", price: 0.75, itemType: type3)
    appDelegate.saveContext()
    
    let item5 = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: appDelegate.managedObjectContext) as! Item
    item5.setValues("vinho", price: 0.35, itemType: type3)
    appDelegate.saveContext()
    
    let item6 = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: appDelegate.managedObjectContext) as! Item
    item6.setValues("chá", price: 0.55, itemType: type1)
    appDelegate.saveContext()
    
    let item7 = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: appDelegate.managedObjectContext) as! Item
    item7.setValues("pastilhas", price: 0.05, itemType: type4)
    appDelegate.saveContext()
    
    let item8 = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: appDelegate.managedObjectContext) as! Item
    item8.setValues("batatas fritas 0.80", price: 0.80, itemType: type4)
    appDelegate.saveContext()
    
    let item9 = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: appDelegate.managedObjectContext) as! Item
    item9.setValues("coca-cola", price: 0.75, itemType: type2)
    appDelegate.saveContext()
    
    let item10 = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: appDelegate.managedObjectContext) as! Item
    item10.setValues("sumol", price: 0.65, itemType: type2)
    
    
    appDelegate.saveContext()
    
}

func generateItemTypes(){
    let item1 = NSEntityDescription.insertNewObjectForEntityForName("ItemType", inManagedObjectContext: appDelegate.managedObjectContext) as! ItemType
    item1.setValues("Cafe")
    
    let item2 = NSEntityDescription.insertNewObjectForEntityForName("ItemType", inManagedObjectContext: appDelegate.managedObjectContext) as! ItemType
    item2.setValues("Bebidas")
    
    
    let item3 = NSEntityDescription.insertNewObjectForEntityForName("ItemType", inManagedObjectContext: appDelegate.managedObjectContext) as! ItemType
    item3.setValues("Alcool")
    
    
    let item4 = NSEntityDescription.insertNewObjectForEntityForName("ItemType", inManagedObjectContext: appDelegate.managedObjectContext) as! ItemType
    item4.setValues("Comer")
    
    
    let item5 = NSEntityDescription.insertNewObjectForEntityForName("ItemType", inManagedObjectContext: appDelegate.managedObjectContext) as! ItemType
    item5.setValues("Tabaco")
    
    
}