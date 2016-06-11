//
//  MainVC.swift
//  CafeCashRegister
//
//  Created by Miguel Santos on 08/04/16.
//  Copyright © 2016 Miguel Santos. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    
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

        
//        if self.isViewLoaded() && (self.view.window != nil) {
//            // viewController is visible
//            self.productsCV.numberOfItemsInSection(0)
//            self.productsCV?.reloadData()
//        }
        
        
        
        self.productsCV.collectionViewLayout.invalidateLayout()
        
        self.productsCV.collectionViewLayout.prepareLayout()
        
        self.productsCV.reloadData()
        
        self.calculatorView.hidden = true
        self.productsCV.hidden = false
        
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
            
            //let item:Item!
            if let item = items[indexPath.row] as? Item {
                cell.configureCell(item)
                
            }
            
            
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

    

    
}

