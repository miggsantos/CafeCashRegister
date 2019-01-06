//
//  Main_RightVC.swift
//  CafeCashRegister
//
//  Created by Miguel Santos on 09/04/16.
//  Copyright © 2016 Miguel Santos. All rights reserved.
//

import UIKit

class Main_RightVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: @IBOutlet
    @IBOutlet weak var bagTV: UITableView!
    @IBOutlet weak var totalLbl: UILabel!
    
    @IBOutlet weak var bill5: UIButton!
    @IBOutlet weak var bill10: UIButton!
    @IBOutlet weak var bill20: UIButton!
    @IBOutlet weak var bill50: UIButton!
    @IBOutlet weak var changeLbl: UILabel!
    
    //MARK: Funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bagTV.delegate = self
        bagTV.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(Main_RightVC.refreshList(_:)),name:NSNotification.Name(rawValue: "refresh"), object: nil)
        
        
        changeLbl.text = ""
        resetBillButtons()
    }
    
    func refreshList(_ notification: Notification){
        //load data here
        self.bagTV.reloadData()
        showTotal()
    }
    


    //MARK: TableView

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BagItemCell", for: indexPath) as? Item_Main_TVCell {
            
            cell.configureCell(addedItems[indexPath.row])
            return cell
            
        } else {
            
            return UITableViewCell()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            addedItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            showTotal()
            
        }
    }
    
    
    //MARK: Buttons Actions
    
    @IBAction func getChange(_ sender: UIButton) {
        
        let total:Double = calculateTotal()
        
        if(total <= 0.0){ return }
        
        activeBillTag = sender.tag
        
        sender.backgroundColor = activeBillColor
        
        showChange( calculateChange(total) )
    }
    
    @IBAction func cleanBag(_ sender: AnyObject) {
        
        addedItems.removeAll(keepingCapacity: false)
        totalLbl.text = "Total: 0.0 \(EURO)";
        
        
        changeLbl.text = "";
        activeBillTag = 0
        resetBillButtons()
        
        bagTV.reloadData()
    }
    
    //MARK: CHANGE
    
    func resetBillButtons(){
        
        bill5.backgroundColor = notActiveBillColor
        bill10.backgroundColor = notActiveBillColor
        bill20.backgroundColor = notActiveBillColor
        bill50.backgroundColor = notActiveBillColor
        
    }
    
    func calculateChange(_ total:Double ) -> Double{
        
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
    
    func showChange(_ change:Double ){
        
        if (change < 0.0) {
            changeLbl.text = "-----";
        }
        else {
            changeLbl.text = change.description + " \(EURO)"
        }
    }
    
    //MARK: TOTAL CALCS
    
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
            total += addedItem.price * Double(addedItem.quantity)
        }
        return total
    }
    


}
