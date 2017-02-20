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
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
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
        
        productListTV.backgroundColor = .clear
        
        picker_Category.dataSource = self
        picker_Category.delegate = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        btn_cancel.isHidden = true
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(DetailsVC.updateProgress(_:)),name:NSNotification.Name(rawValue: "updateProgress"), object: nil)
        
        fetchTypes()
        
        attemptFetch()
        
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismiss(animated: true, completion: nil)
        itemImage.image = image
        
        editItemImageFlag = true
    }
    
    //MARK: Fetchs
    
    func fetchTypes(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemType")
        
        do {
            
            self.types = try appDelegate.managedObjectContext.fetch(fetchRequest) as! [ItemType]
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
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        fetchRequest.propertiesToGroupBy = ["itemtype.type"]
        fetchRequest.resultType = .dictionaryResultType
        
        
        var expressionDescriptions = [AnyObject]()
        //expressionDescriptions.append("created")
        expressionDescriptions.append("name" as AnyObject)
        expressionDescriptions.append("price" as AnyObject)
        expressionDescriptions.append("image" as AnyObject)
        
        
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        let sortDescriptor = NSSortDescriptor(key: "itemtype.type", ascending: true)
        //let sortDescriptor2 = NSSortDescriptor(key: "itemtype.created", ascending: true)
        let sortDescriptor3 = NSSortDescriptor(key: "created", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor, sortDescriptor3]
 
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: section, cacheName: nil)
        
        controller.delegate = self
        
        fetchedResultsController = controller
    }
    
    //MARK: Buttons Actions
    
    @IBAction func addImage(_ sender: AnyObject) {
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.modalPresentationStyle = UIModalPresentationStyle.popover
 
        self.present(imagePicker, animated: true, completion: nil)
        
        let popper = imagePicker.popoverPresentationController
        popper?.sourceView = self.view
        
    }
    
    @IBAction func saveProduct(_ sender: AnyObject) {

        
        if let name = txt_name.text, name != "",
           let price = txt_price.text, price != ""
        {
            
            let t = types[picker_Category.selectedRow(inComponent: 0)]

            
            let context = appDelegate.managedObjectContext
            
            let item:Item
            
            
            if editItemFlag { // edit
                
                editItemFlag = false
                
                item = editItem!
                item.setValues(name, price: NSNumber.init(value: Double(price)! as Double), itemType: t)
                
                if editItemImageFlag {
                    editItemImageFlag = false
                    var img = itemImage.image!
                    img = img.resize(0.1)
                    item.setItemImage(img.resize(0.1))
                
                } else {
                    item.setItemImage(itemImage.image!)
                }
                
            } else { // insert
                
                let entity = NSEntityDescription.entity(forEntityName: "Item", in: context)!
                item = Item(entity: entity, insertInto: context)
                
                item.setValues(name, price: NSNumber.init(value: Double(price)! as Double), itemType: t)
                
                
                let img = itemImage.image!.imageWithSize_AspectFill(CGSize(width: 117, height: 117))
                
                item.setItemImage(img)
                
                context.insert(item)
            
            }
            
            do {
                try context.save()
            } catch {
                print("Could not save Item")
            }

            cleanfields()

        }
        
    }

    @IBAction func cancelPressed(_ sender: AnyObject) {
        cleanfields()
        productListTV.setEditing(false, animated: true)
    }
    
    

    @IBAction func OpenPopUpConfig(_ sender: AnyObject) {
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpOnlineDataID") as! PopUpOnlineDataVC
        
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
        
        
    }
    
    
    @IBAction func getDataOnlinePressed(_ sender: AnyObject) {
        
        guard let url = defaults.string(forKey: RemoteDataKeys.dataUrl), url != "" else {
            
            
            let alert = UIAlertController(title: "Configuração em falta", message: "É necessário configurar o url dos dados remotos!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Fechar", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return;
        }
        
//        if let imagesUrlStored = defaults.stringForKey(RemoteDataKeys.imagesUrl) {
//            imagesUrl.text = imagesUrlStored
//        }
        

        let alertView = UIAlertController(title: "Obter dados online", message: "Serão obtido os dados remotos. Quer continuar?", preferredStyle: UIAlertControllerStyle.alert)
        alertView.addAction(UIAlertAction(title: "Não", style: UIAlertActionStyle.cancel, handler: nil))
        alertView.addAction(UIAlertAction(title: "Sim", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
            
            self.getOnlineData()
        }))
        
        self.present(alertView, animated: true, completion: nil)

    }
    
    
    func getOnlineData(){
    
        btn_getOnlineData.isHidden = true
        let result = DataService.instance.processOnlineData()
        
        if result.dataExists {
            let alertView = UIAlertController(title: "Inserir dados remotos", message: "Foram obtidos \(result.typeCount) tipos e \(result.itemsCount) items. Todos os dados serão eliminados e substituidos pelas infomação online. Quer continuar?", preferredStyle: UIAlertControllerStyle.alert)
                    alertView.addAction(UIAlertAction(title: "Não", style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction!) in
                        
                        self.btn_getOnlineData.isHidden = false
                    
                    }))
                    alertView.addAction(UIAlertAction(title: "Sim", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
            
                        self.insertOnlineData()
                    }))
            
                    self.present(alertView, animated: true, completion: nil)
        }
        
        
        
    }
    
    func insertOnlineData(){
    
        DataService.instance.insertOnlineData()
        
        btn_getOnlineData.isHidden = false
    }
    
    
    func updateProgress(_ notification: Notification){
        
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
        btn_cancel.isHidden = true
        btn_save.titleLabel?.text = "Guardar"
        createEditView.backgroundColor = UIColor.white
    }
    
    
    //MARK: Pick View
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let itemtype = types[row]
        return itemtype.type
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
    }
    
    
    //MARK: Table View
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.name
        }
        
        return ""
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections{
            return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Apagar") { action, index in
            
            let managedObject:NSManagedObject = self.fetchedResultsController.object(at: indexPath) as! NSManagedObject
            let context = appDelegate.managedObjectContext
            context.delete(managedObject)
            do {
                try context.save()
            } catch {
                print("Could not delete")
            }
            
            
        }

        let edit = UITableViewRowAction(style: .normal, title: "Editar") { action, index in
            let item = self.fetchedResultsController.object(at: indexPath) as! Item
            self.txt_price.text = "\(item.price!)"
            self.txt_name.text = item.name
            self.itemImage.image = item.getItemImg()
            
            
            if let row = self.types.index(of: item.itemtype!) {
                self.picker_Category.selectRow(row, inComponent: 0, animated: false)
            }
            
            self.editItemFlag = true
            self.editItem = item
            self.btn_cancel.isHidden = false
            self.btn_save.titleLabel?.text = "Guardar Alterações"
            self.createEditView.backgroundColor = UIColor.lightGray
            
            
        }
        edit.backgroundColor = UIColor.lightGray

        return [edit, delete]
    }
    

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsCell", for: indexPath) as? ProductDetailsCell {
            
            configureCell(cell, indexPath: indexPath)
            
            return cell
            
        } else {
            
            return ProductDetailsCell()
        }
    }
    
    
    func configureCell(_ cell: ProductDetailsCell, indexPath: IndexPath){
        
        if let item = fetchedResultsController.object(at: indexPath) as? Item {
            //update data
            cell.configureCell(item)
            cell.setTransparent()
        }
        
    }
    
    //MARK: CONTROLLER
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        productListTV.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        productListTV.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            productListTV.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            productListTV.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default: break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                
                productListTV.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                
                productListTV.deleteRows(at: [indexPath], with: .fade)
            }
            break
            
        case .update:
            if let indexPath = indexPath {
                
                let cell = productListTV.cellForRow(at: indexPath) as! ProductDetailsCell
                configureCell(cell, indexPath: indexPath)
            }
            break
            
        case .move:
            if let indexPath = indexPath {
                productListTV.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                
                productListTV.insertRows(at: [newIndexPath], with: .fade)
            }
            
            break
            
        }
    }
    

}
