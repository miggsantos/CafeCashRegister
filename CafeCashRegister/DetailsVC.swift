//
//  DetailsVC.swift
//  CafeCashRegister
//
//  Created by Miguel Santos on 03/04/16.
//  Copyright © 2016 Miguel Santos. All rights reserved.
//

import UIKit
import CoreData

class DetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSFetchedResultsControllerDelegate  {

    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var txt_price: UITextField!
    @IBOutlet weak var picker_Category: UIPickerView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var productListTV: UITableView!
    
    var fetchedResultsController: NSFetchedResultsController!
    
    var imagePicker: UIImagePickerController!
    
    var types = [ItemType]()
    
    var items = [Item]()
    
    var results:[[String:Item]]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        productListTV.delegate = self
        productListTV.dataSource = self
        
        picker_Category.dataSource = self
        picker_Category.delegate = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        fetchTypes()
        
        attemptFetch()
        
        
    }
    
    func fetchTypes(){
        let fetchRequest = NSFetchRequest(entityName: "ItemType")
        
        do {
            
            self.types = try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest) as! [ItemType]
            self.picker_Category.reloadAllComponents()
            
        } catch {
            
            print("Erro")
        }
        
    }


    func attemptFetch(){
        setFetchedResults()
        
        do {
            try self.fetchedResultsController.performFetch()
            
        } catch {
            let error = error as NSError
            print("\(error), \(error.userInfo)")
            
        }
        
        
    }
    
    func setFetchedResultsByGroup(){
        //let section : String? = segment.selectedSegmentIndex == 1 ? "store.name" : nil
        
        let section : String? =  "itemtype.type"
        
        let fetchRequest = NSFetchRequest(entityName: "Item")
        fetchRequest.propertiesToGroupBy = ["itemtype.type"]
        fetchRequest.resultType = .DictionaryResultType
        
        
        var expressionDescriptions = [AnyObject]()
        //expressionDescriptions.append("created")
        expressionDescriptions.append("name")
        expressionDescriptions.append("price")
        expressionDescriptions.append("image")
        
        
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: true)
        //let sortDescriptor2 = NSSortDescriptor(key: "itemtype.created", ascending: true)
        //fetchRequest.sortDescriptors = [sortDescriptor, sortDescriptor2]
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.propertiesToFetch = expressionDescriptions
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: section, cacheName: nil)
        
        //controller.delegate = self
        
        fetchedResultsController = controller
        
        
    }
    
    func setFetchedResults(){
        //let section : String? = segment.selectedSegmentIndex == 1 ? "store.name" : nil
        
        let section : String? =  "itemtype.type"
        
        let fetchRequest = NSFetchRequest(entityName: "Item")

        
        
        let sortDescriptor = NSSortDescriptor(key: "itemtype.type", ascending: true)
        //let sortDescriptor2 = NSSortDescriptor(key: "itemtype.created", ascending: true)
        let sortDescriptor3 = NSSortDescriptor(key: "created", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor, sortDescriptor3]
 
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: section, cacheName: nil)
        
        controller.delegate = self
        
        fetchedResultsController = controller
        
        
    }

    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        itemImage.image = image
    }
    
    
    @IBAction func addImage(sender: AnyObject) {
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.modalPresentationStyle = UIModalPresentationStyle.Popover
 
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
        let popper = imagePicker.popoverPresentationController
        popper?.sourceView = self.view
        
    }
    
    @IBAction func saveProduct(sender: AnyObject) {

        
        if let name = txt_name.text where name != "" {
            

            let context = appDelegate.managedObjectContext
            let entity = NSEntityDescription.entityForName("Item", inManagedObjectContext: context)!
            let item = Item(entity: entity, insertIntoManagedObjectContext: context)
            
            
            let t = types[picker_Category.selectedRowInComponent(0)]
            
            print(t.type)
            print(t.created?.description)
            
            item.setValues(txt_name.text!, price: NSNumber.init(double: Double(txt_price.text!)!), itemType: t)
            
            //items.append(item)
            
            context.insertObject(item)
            
            
            do {
                try context.save()
            } catch {
                print("Could not save recipe")
            }
            
 
            cleanfields()
    
            
            //self.navigationController?.popViewControllerAnimated(true)
            
        }
        
    }
    
    func cleanfields(){
        txt_name.text = ""
        txt_price.text = ""
        itemImage.image = UIImage(named: "add.png")
        

    }
   

    
    
    //Pick View
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let itemtype = types[row]
        return itemtype.type
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
    }
    

    
    
    // Table View
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return types[section].type
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.name
        }
        
        return ""
        
    }
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let vw = UIView()
//        vw.backgroundColor = UIColor.lightGrayColor()
//        
//        return vw
//    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections{
            
            //print("sections.count= \(sections.count)")
            return sections.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //print("numberOfRowsInSection= \(section)")
        //print("numberOfRowsInSection= \(types[section].type)")
        
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            
            //print("sectionInfo.numberOfObjects= \(currentSection.numberOfObjects)")
            return currentSection.numberOfObjects
        }
        
        return 0
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("ProductDetailsCell", forIndexPath: indexPath) as? ProductDetailsCell {
            
            //cell.configureCell(allProducts[indexPath.row])
            configureCell(cell, indexPath: indexPath)
            
            return cell
            
        } else {
            
            return ProductDetailsCell()
        }
    }
    
    func configureCell(cell: ProductDetailsCell, indexPath: NSIndexPath){
        
        if let item = fetchedResultsController.objectAtIndexPath(indexPath) as? Item {
            //update data
            cell.configureCell(item)
        }
        
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        productListTV.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        productListTV.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            productListTV.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Delete:
            productListTV.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        default: break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            if let indexPath = newIndexPath {
                
                productListTV.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break
        case .Delete:
            if let indexPath = indexPath {
                
                productListTV.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break
            
        case .Update:
            if let indexPath = indexPath {
                
                let cell = productListTV.cellForRowAtIndexPath(indexPath) as! ProductDetailsCell
                configureCell(cell, indexPath: indexPath)
            }
            break
            
        case .Move:
            if let indexPath = indexPath {
                productListTV.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            
            if let newIndexPath = newIndexPath {
                
                productListTV.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            }
            
            break
            
        }
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
