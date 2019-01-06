//
//  CalculatorView.swift
//  CafeCashRegister
//
//  Created by Miguel Santos on 30/03/16.
//  Copyright © 2016 Miguel Santos. All rights reserved.
//

import UIKit

class CalculatorView: UIView {

    var runningNumber = ""
    
    @IBOutlet weak var calcDisplay: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    @IBAction func numberPressed(_ sender: UIButton) {
        
        if(sender.tag == -1){
            
            if !runningNumber.contains(".") {
                runningNumber += "."
            }
            
        } else {
            runningNumber += "\(sender.tag)"
        }
        
        calcDisplay.text = "\(runningNumber) \(EURO) "
        
    }
    
    @IBAction func backspacePressed(_ sender: AnyObject) {
        
        runningNumber = String(runningNumber.characters.dropLast())
        calcDisplay.text = "\(runningNumber) \(EURO) "
    }
    
    @IBAction func addPressed(_ sender: AnyObject) {
        
        if let calcValue = Double(runningNumber)  {
            
            addedItems.append(AddedItem(objectId: "" , name: "valor manual", price: calcValue, image: UIImage(named: "euro.png")! ))
            
            refreshTableView()
            
            runningNumber = ""
            calcDisplay.text = "0.00\(EURO) "
            
        } else {
            print("not double")
        }
    }
    
    
    func refreshTableView(){
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: nil)
    }

}
