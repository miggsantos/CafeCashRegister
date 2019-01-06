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
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    //MARK: Funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productsCV.delegate = self
        productsCV.dataSource = self
        
        
        calculatorView.isHidden = true
        productsCV.isHidden = false
        
        //generateItemTypes()
        //generateTestData()

        fetchAndSetResults()
        
    }
    
    func refreshTableView(){
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: nil)
    }
    
    
    //MARK: Fetch
    
    func fetchAndSetResults(){
        
        let context = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do{
            let results = try context.fetch(fetchRequest)
            self.items = results as! [Item]
        } catch let err as NSError {
            print(err.debugDescription)
            
        }

    }
    
    func fetchAndSetResultsByItemType(_ type:String?){
        

        
        let context = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let typeName = type {
        
            let predicate = NSPredicate(format: "itemtype.type = %@", typeName )
            fetchRequest.predicate = predicate
                    
        }
        
        
        do{
            let results = try context.fetch(fetchRequest)
            self.items = results as! [Item]
        } catch let err as NSError {
            print(err.debugDescription)
            
        }
        
    }
    
    //MARK: Button Actions
    
    @IBAction func changeCategory(_ sender: UIButton) {
        
        
        if(!self.calculatorView.isHidden){
            return;
        }
        
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
        

        self.productsCV.reloadData()
        
        self.calculatorView.isHidden = true
        self.productsCV.isHidden = false
        
    }
    
    
    @IBAction func calculatorBtnPressed(_ sender: AnyObject) {
        
        if calculatorView.isHidden {
            productsCV.isHidden = true
            calculatorView.isHidden = false
            
        }
        else {
            calculatorView.isHidden = true
            productsCV.isHidden = false
        }
        
    }
    
    
    

    //MARK: CollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ItemCell_CV {
            
            cell.configureCell( items[indexPath.row] )

            return cell
            
        } else {
            return UICollectionViewCell()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: 117, height: 117)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item:Item!
        item = items[indexPath.row]

        if let index = addedItems.index(where: {$0.id == (item.objectID.uriRepresentation().absoluteString) }){
            addedItems[index].quantity += 1
        } else {
            addedItems.append(AddedItem(objectId: (item.objectID.uriRepresentation().absoluteString) , name: item.name!, price: Double(item.price!), image: item.getItemImg()  ))
        }
        
        refreshTableView()
    }

    
}

