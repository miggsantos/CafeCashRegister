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
    
    
    @IBAction func numberPressed(sender: UIButton) {
        
        if(sender.tag == -1){
            
            if !runningNumber.containsString(".") {
                runningNumber += "."
            }
            
        } else {
            runningNumber += "\(sender.tag)"
        }
        
        calcDisplay.text = "\(runningNumber) \(EURO) "
        
    }
    
    @IBAction func backspacePressed(sender: AnyObject) {
        
        runningNumber = String(runningNumber.characters.dropLast())
        calcDisplay.text = "\(runningNumber) \(EURO) "
    }
    
    @IBAction func addPressed(sender: AnyObject) {
        
        if let calcValue = Double(runningNumber)  {
            
            bagItems.append(Product.init( productId: 0,name: "valor manual", price: calcValue, category: Product.Category.TODOS, image: "euro.png" ))
            
            //bagTV.reloadData()
            //showTotal()
            
            refreshTableView()
            
            runningNumber = ""
            calcDisplay.text = "\(EURO) "
            
        } else {
            print("not double")
        }
    }
    
    
    func refreshTableView(){
        
        NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil)
    }

}
