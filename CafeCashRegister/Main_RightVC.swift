//
//  Main_RightVC.swift
//  CafeCashRegister
//
//  Created by Miguel Santos on 09/04/16.
//  Copyright © 2016 Miguel Santos. All rights reserved.
//

import UIKit

class Main_RightVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var bagTV: UITableView!
    @IBOutlet weak var totalLbl: UILabel!
    
    @IBOutlet weak var bill5: UIButton!
    @IBOutlet weak var bill10: UIButton!
    @IBOutlet weak var bill20: UIButton!
    @IBOutlet weak var bill50: UIButton!
    @IBOutlet weak var changeLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bagTV.delegate = self
        bagTV.dataSource = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RigthVC.refreshList(_:)),name:"refresh", object: nil)
        
        
        changeLbl.text = ""
        resetBillButtons()
    }
    
    func refreshList(notification: NSNotification){
        //load data here
        self.bagTV.reloadData()
        showTotal()
    }
    
    
    
    
    // **************************
    // ******* TableView ********
    // **************************
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addedItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("BagItemCell", forIndexPath: indexPath) as? Item_Main_TVCell {
            
            cell.configureCell(addedItems[indexPath.row])
            return cell
            
        } else {
            
            return UITableViewCell()
        }
        
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            addedItems.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            showTotal()
            
        }
    }
    
    
    
    
    // *****************************
    // ********* CHANGE ************
    // *****************************
    
    func resetBillButtons(){
        
        bill5.backgroundColor = notActiveBillColor
        bill10.backgroundColor = notActiveBillColor
        bill20.backgroundColor = notActiveBillColor
        bill50.backgroundColor = notActiveBillColor
        
    }
    
    
    @IBAction func getChange(sender: UIButton) {
        
        let total:Double = calculateTotal()
        
        if(total <= 0.0){ return }
        
        activeBillTag = sender.tag
        
        sender.backgroundColor = activeBillColor
        
        showChange( calculateChange(total) )
    }
    
    
    func calculateChange(total:Double ) -> Double{
        
        resetBillButtons()
        
        var change:Double = 0.0
        
        switch(activeBillTag){
            
        case 1:
            
            change = 5.0 - total
            bill5.backgroundColor = activeBillColor
            break
        case 2:
            change = 10.0 - total
            bill10.backgroundColor = activeBillColor
            break
        case 3:
            change = 20.0 - total
            bill20.backgroundColor = activeBillColor
            break
        case 4:
            change = 50.0 - total
            bill50.backgroundColor = activeBillColor
            break
            
        default:
            break
            
        }
        
        return change
    }
    
    func showChange(change:Double ){
        
        if (change < 0.0) {
            changeLbl.text = "Erro - Sem troco!"
        }
        else {
            changeLbl.text = change.description + " \(EURO)"
        }
    }
    
    
    func showTotal(){
        
        let total:Double = calculateTotal()
        
        totalLbl.text = "Total: " + total.description + " \(EURO)"
        
        if(activeBillTag > 0){
            showChange( calculateChange(total) )
        }
        
    }
    
    func calculateTotal() -> Double{
        var total = 0.0;
        for addedItem in addedItems{
            //total += (p.price as  * Double(p.quantity) )
            total += addedItem.price * Double(addedItem.quantity)
        }
        return total
    }
    
    @IBAction func cleanBag(sender: AnyObject) {
        
        addedItems.removeAll(keepCapacity: false)
        totalLbl.text = "Total: 0.0 \(EURO)";
        
        
        changeLbl.text = "";
        activeBillTag = 0
        resetBillButtons()
        
        bagTV.reloadData()
    }

}
