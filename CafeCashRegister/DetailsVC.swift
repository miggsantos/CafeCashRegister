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

    //MARK: @IBOutlet
    
    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var txt_price: UITextField!
    @IBOutlet weak var picker_Category: UIPickerView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var productListTV: UITableView!
    
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_save: UIButton!
    @IBOutlet weak var createEditView: UIView!
    @IBOutlet weak var btn_getOnlineData: UIButton!
    
    @IBOutlet weak var lbl_progress: UILabel!
    
    //MARK: Variables
    
    var fetchedResultsController: NSFetchedResultsController!
    
    var imagePicker: UIImagePickerController!
    
    var types = [ItemType]()
    
    var editItem: Item?
    var editItemFlag: Bool = false
    var editItemImageFlag: Bool = false
    

    //MARK: FUNCS
    
    override func viewDidLoad() {
        super.viewDidLoad()

        productListTV.delegate = self
        productListTV.dataSource = self
        
        productListTV.backgroundColor = .clearColor()
        
        picker_Category.dataSource = self
        picker_Category.delegate = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        btn_cancel.hidden = true
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DetailsVC.updateProgress(_:)),name:"updateProgress", object: nil)
        
        fetchTypes()
        
        attemptFetch()
        
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        itemImage.image = image
        
        editItemImageFlag = true
    }
    
    //MARK: Fetchs
    
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
    
    //MARK: Buttons Actions
    
    @IBAction func addImage(sender: AnyObject) {
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.modalPresentationStyle = UIModalPresentationStyle.Popover
 
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
        let popper = imagePicker.popoverPresentationController
        popper?.sourceView = self.view
        
    }
    
    @IBAction func saveProduct(sender: AnyObject) {

        
        if let name = txt_name.text where name != "",
           let price = txt_price.text where price != ""
        {
            
            let t = types[picker_Category.selectedRowInComponent(0)]

            
            let context = appDelegate.managedObjectContext
            
            let item:Item
            
            
            if editItemFlag { // edit
                
                editItemFlag = false
                
                item = editItem!
                item.setValues(name, price: NSNumber.init(double: Double(price)!), itemType: t)
                
                if editItemImageFlag {
                    editItemImageFlag = false
                    var img = itemImage.image!
                    img = img.resize(0.1)
                    item.setItemImage(img.resize(0.1))
                
                } else {
                    item.setItemImage(itemImage.image!)
                }
                
            } else { // insert
                
                let entity = NSEntityDescription.entityForName("Item", inManagedObjectContext: context)!
                item = Item(entity: entity, insertIntoManagedObjectContext: context)
                
                item.setValues(name, price: NSNumber.init(double: Double(price)!), itemType: t)
                
                
                let img = itemImage.image!.imageWithSize_AspectFill(CGSize(width: 117, height: 117))
                
                item.setItemImage(img)
                
                context.insertObject(item)
            
            }
            
            do {
                try context.save()
            } catch {
                print("Could not save Item")
            }

            cleanfields()

        }
        
    }

    @IBAction func cancelPressed(sender: AnyObject) {
        cleanfields()
        productListTV.setEditing(false, animated: true)
    }
    
    

    @IBAction func OpenPopUpConfig(sender: AnyObject) {
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("sbPopUpOnlineDataID") as! PopUpOnlineDataVC
        
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMoveToParentViewController(self)
        
        
        
    }
    
    
    @IBAction func getDataOnlinePressed(sender: AnyObject) {
        
        guard let url = defaults.stringForKey(RemoteDataKeys.dataUrl) where url != "" else {
            
            
            let alert = UIAlertController(title: "Configuração em falta", message: "É necessário configurar o url dos dados remotos!", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Fechar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            return;
        }
        
//        if let imagesUrlStored = defaults.stringForKey(RemoteDataKeys.imagesUrl) {
//            imagesUrl.text = imagesUrlStored
//        }
        
        
        
        
        let alertView = UIAlertController(title: "Obter dados online", message: "Serão obtido os dados remotos. Quer continuar?", preferredStyle: UIAlertControllerStyle.Alert)
        alertView.addAction(UIAlertAction(title: "Não", style: UIAlertActionStyle.Cancel, handler: nil))
        alertView.addAction(UIAlertAction(title: "Sim", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            
            self.getOnlineData()
        }))
        
        self.presentViewController(alertView, animated: true, completion: nil)
        
        
        
        
        
//        let alertView = UIAlertController(title: "Obter dados online", message: "Todos os dados serão eliminados e substituidos pelas infomação online. Quer continuar?", preferredStyle: UIAlertControllerStyle.Alert)
//        alertView.addAction(UIAlertAction(title: "Não", style: UIAlertActionStyle.Cancel, handler: nil))
//        alertView.addAction(UIAlertAction(title: "Sim", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
//            
//            self.getOnlineData()
//        }))
//        
//        self.presentViewController(alertView, animated: true, completion: nil)
        
        //DataService.instance.processOnlineData()
        
    }
    
    
    func getOnlineData(){
    
        btn_getOnlineData.hidden = true
        let result = DataService.instance.processOnlineData()
        
        if result.dataExists {
            let alertView = UIAlertController(title: "Inserir dados remotos", message: "Foram obtidos \(result.typeCount) tipos e \(result.itemsCount) items. Todos os dados serão eliminados e substituidos pelas infomação online. Quer continuar?", preferredStyle: UIAlertControllerStyle.Alert)
                    alertView.addAction(UIAlertAction(title: "Não", style: UIAlertActionStyle.Cancel, handler: nil))
                    alertView.addAction(UIAlertAction(title: "Sim", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            
                        self.insertOnlineData()
                    }))
            
                    self.presentViewController(alertView, animated: true, completion: nil)
        }
        
        
        
    }
    
    func insertOnlineData(){
    
        DataService.instance.insertOnlineData()
        
        btn_getOnlineData.hidden = false
    }
    
    
    func updateProgress(notification: NSNotification){
        
        if let dict = notification.object as? [String:AnyObject] {
            
            let total = dict["total"]
            let current = dict["current"]
            
            if let total = total as? Int, let current = current as? Int {
                lbl_progress.text = "\(current) de \(total)"
                
                print("updateProgress \(current) de \(total)")
            }

        }

    }
    
    
    func cleanfields(){
        txt_name.text = ""
        txt_price.text = ""
        itemImage.image = UIImage(named: "add.png")
        btn_cancel.hidden = true
        btn_save.titleLabel?.text = "Guardar"
        createEditView.backgroundColor = UIColor.whiteColor()
    }
    
    
    //MARK: Pick View
    
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
    
    
    //MARK: Table View
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.name
        }
        
        return ""
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections{
            return sections.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Destructive, title: "Apagar") { action, index in
            
            let managedObject:NSManagedObject = self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
            let context = appDelegate.managedObjectContext
            context.deleteObject(managedObject)
            do {
                try context.save()
            } catch {
                print("Could not delete")
            }
            
            
        }

        let edit = UITableViewRowAction(style: .Normal, title: "Editar") { action, index in
            let item = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Item
            self.txt_price.text = "\(item.price!)"
            self.txt_name.text = item.name
            self.itemImage.image = item.getItemImg()
            
            
            if let row = self.types.indexOf(item.itemtype!) {
                self.picker_Category.selectRow(row, inComponent: 0, animated: false)
            }
            
            self.editItemFlag = true
            self.editItem = item
            self.btn_cancel.hidden = false
            self.btn_save.titleLabel?.text = "Guardar Alterações"
            self.createEditView.backgroundColor = UIColor.lightGrayColor()
            
            
        }
        edit.backgroundColor = UIColor.lightGrayColor()

        return [edit, delete]
    }
    

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("ProductDetailsCell", forIndexPath: indexPath) as? ProductDetailsCell {
            
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
            cell.setTransparent()
        }
        
    }
    
    //MARK: CONTROLLER
    
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
    

}
