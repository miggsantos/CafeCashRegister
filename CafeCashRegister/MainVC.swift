//
//  MainVC.swift
//  CafeCashRegister
//
//  Created by Miguel Santos on 08/04/16.
//  Copyright © 2016 Miguel Santos. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    

    
    var items = [Item]()
    
    var fetchedResultsController: NSFetchedResultsController!
    
    @IBOutlet weak var productsCV: UICollectionView!
    
    @IBOutlet weak var calculatorView: CalculatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productsCV.delegate = self
        productsCV.dataSource = self
        
        
        calculatorView.hidden = true
        productsCV.hidden = false
        
        //generateItemTypes()
        //generateTestData()

        
        
        fetchAndSetResults()
        
    }
    
    func fetchAndSetResults(){
        
        let context = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Item")
        
        do{
            let results = try context.executeFetchRequest(fetchRequest)
            self.items = results as! [Item]
        } catch let err as NSError {
            print(err.debugDescription)
            
        }

    }
    
    func fetchAndSetResultsByItemType(type:String?){
        

        
        let context = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Item")
        
        if let typeName = type {
        
            let predicate = NSPredicate(format: "itemtype.type = %@", typeName )
            fetchRequest.predicate = predicate
                    
        }
        
        
        do{
            let results = try context.executeFetchRequest(fetchRequest)
            self.items = results as! [Item]
        } catch let err as NSError {
            print(err.debugDescription)
            
        }
        
    }
    
    
    @IBAction func changeCategory(sender: UIButton) {
        
        print(sender.tag)
        
        switch sender.tag {
        case 0:
            fetchAndSetResultsByItemType(nil)
            break;
        case 1:
            fetchAndSetResultsByItemType("Cafe")
            break;
        case 2:
            fetchAndSetResultsByItemType("Alcool")
            break;
        case 3:
            fetchAndSetResultsByItemType("Comer")
            break;
        case 4:
            fetchAndSetResultsByItemType("Tabaco")
            break;
            
        default:
            break;
        }
        

        

       
//        dispatch_async(dispatch_get_main_queue(), {
//        })

//        self.productsCV.collectionViewLayout.invalidateLayout()
//        self.productsCV.reloadData()
//        
        self.calculatorView.hidden = true
        self.productsCV.hidden = false
        
//        if self.isViewLoaded() && (self.view.window != nil) {
//            // viewController is visible
//            self.productsCV.numberOfItemsInSection(0)
//            self.productsCV?.reloadData()
//        }
        
        
        
        self.productsCV.collectionViewLayout.invalidateLayout()
        
        self.productsCV.collectionViewLayout.prepareLayout()
        
        self.productsCV.reloadData()
    }
    
    
    @IBAction func calculatorBtnPressed(sender: AnyObject) {
        
        if calculatorView.hidden {
            productsCV.hidden = true
            calculatorView.hidden = false
            
        }
        else {
            calculatorView.hidden = true
            productsCV.hidden = false
        }
        
    }
    
    
    // **************************
    // ***** CollectionView *****
    // **************************


    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {

        return 1
    }
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return items.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProductCell", forIndexPath: indexPath) as? ItemCell_CV {
            
            let item:Item!
            item = items[indexPath.row]
            cell.configureCell(item)
            
            return cell
            
        } else {
            return UICollectionViewCell()
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(117, 117)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let item:Item!
        item = items[indexPath.row]
        
        //print(item.objectID.URIRepresentation().absoluteString)

        
        if let index = addedItems.indexOf({$0.id == (item.objectID.URIRepresentation().absoluteString) }){
            addedItems[index].quantity += 1
        } else {
            addedItems.append(AddedItem(objectId: (item.objectID.URIRepresentation().absoluteString) , name: item.name!, price: Double(item.price!) ))
        }
        
        refreshTableView()
    }
    
    func configureCell(cell: ItemCell_CV, indexPath: NSIndexPath){
        
        if let item = fetchedResultsController.objectAtIndexPath(indexPath) as? Item {
            //update data
            cell.configureCell(item)
        }
        
    }

    
    func refreshTableView(){
        
        NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil)
    }
    
    
    
    func generateTestData(){
        
        let type1 = NSEntityDescription.insertNewObjectForEntityForName("ItemType", inManagedObjectContext: appDelegate.managedObjectContext) as! ItemType
        type1.type = "Cafe"
        
        let type2 = NSEntityDescription.insertNewObjectForEntityForName("ItemType", inManagedObjectContext: appDelegate.managedObjectContext) as! ItemType
        type2.type = "Bebidas"
        
        let type3 = NSEntityDescription.insertNewObjectForEntityForName("ItemType", inManagedObjectContext: appDelegate.managedObjectContext) as! ItemType
        type3.type = "Alcool"
        
        let type4 = NSEntityDescription.insertNewObjectForEntityForName("ItemType", inManagedObjectContext: appDelegate.managedObjectContext) as! ItemType
        type4.type = "Comer"
        
        let type5 = NSEntityDescription.insertNewObjectForEntityForName("ItemType", inManagedObjectContext: appDelegate.managedObjectContext) as! ItemType
        type5.type = "Tabaco"
        
        
        appDelegate.saveContext()
        
        
     
        
        let item1 = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: appDelegate.managedObjectContext) as! Item
        item1.name = "café"
        item1.price = 0.55
        item1.itemtype = type1
        
        let item2 = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: appDelegate.managedObjectContext) as! Item
        item2.name = "descafeinado"
        item2.price = 0.45
        item2.itemtype = type1
        
        let item3 = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: appDelegate.managedObjectContext) as! Item
        item3.name = "carioca"
        item3.price = 0.55
        item3.itemtype = type1
        
        let item4 = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: appDelegate.managedObjectContext) as! Item
        item4.name = "cerveja"
        item4.price = 0.55
        item4.itemtype = type3
        
        let item5 = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: appDelegate.managedObjectContext) as! Item
        item5.name = "vinho"
        item5.price = 0.55
        item5.itemtype = type3
        
        let item6 = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: appDelegate.managedObjectContext) as! Item
        item6.name = "chá"
        item6.price = 0.55
        item6.itemtype = type1
        
        let item7 = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: appDelegate.managedObjectContext) as! Item
        item7.name = "pastilhas"
        item7.price = 0.55
        item7.itemtype = type4
        
        let item8 = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: appDelegate.managedObjectContext) as! Item
        item8.name = "atatas fritas 0.80"
        item8.price = 0.55
        item8.itemtype = type4
        
        let item9 = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: appDelegate.managedObjectContext) as! Item
        item9.name = "coca-cola"
        item9.price = 0.55
        item9.itemtype = type2

        let item10 = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: appDelegate.managedObjectContext) as! Item
        item10.name = "sumol"
        item10.price = 0.55
        item10.itemtype = type2
        
        appDelegate.saveContext()
        
    }
    
    func generateItemTypes(){
        let item1 = NSEntityDescription.insertNewObjectForEntityForName("ItemType", inManagedObjectContext: appDelegate.managedObjectContext) as! ItemType
        item1.type = "Cafe"
        
        let item2 = NSEntityDescription.insertNewObjectForEntityForName("ItemType", inManagedObjectContext: appDelegate.managedObjectContext) as! ItemType
        item2.type = "Bebidas"
        
        let item3 = NSEntityDescription.insertNewObjectForEntityForName("ItemType", inManagedObjectContext: appDelegate.managedObjectContext) as! ItemType
        item3.type = "Alcool"
        
        let item4 = NSEntityDescription.insertNewObjectForEntityForName("ItemType", inManagedObjectContext: appDelegate.managedObjectContext) as! ItemType
        item4.type = "Comer"
        
        let item5 = NSEntityDescription.insertNewObjectForEntityForName("ItemType", inManagedObjectContext: appDelegate.managedObjectContext) as! ItemType
        item5.type = "Tabaco"

        
        appDelegate.saveContext()
        
    }
    
}

