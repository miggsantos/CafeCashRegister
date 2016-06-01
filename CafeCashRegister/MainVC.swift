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
    
    //Mark: IBOutlet
    
    @IBOutlet weak var productsCV: UICollectionView!
    @IBOutlet weak var calculatorView: CalculatorView!
    
    //MARK: Vars
    
    var items = [Item]()
    var fetchedResultsController: NSFetchedResultsController!
    
    //MARK: Funcs
    
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
    
    func refreshTableView(){
        
        NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil)
    }
    
    
    //MARK: Fetch
    
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
    
    //MARK: Button Actions
    
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
            fetchAndSetResultsByItemType("Bebidas")
            break;
        case 3:
            fetchAndSetResultsByItemType("Alcool")
            break;
        case 4:
            fetchAndSetResultsByItemType("Comer")
            break;
        case 5:
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
    
    
    

    //MARK: CollectionView
    
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
            addedItems.append(AddedItem(objectId: (item.objectID.URIRepresentation().absoluteString) , name: item.name!, price: Double(item.price!), image: item.getItemImg()  ))
        }
        
        refreshTableView()
    }
    
//    func configureCell(cell: ItemCell_CV, indexPath: NSIndexPath){
//        
//        if let item = fetchedResultsController.objectAtIndexPath(indexPath) as? Item {
//            //update data
//            cell.configureCell(item)
//        }
//        
//    }

    
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
    
}

