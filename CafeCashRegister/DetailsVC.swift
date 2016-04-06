//
//  DetailsVC.swift
//  CafeCashRegister
//
//  Created by Miguel Santos on 03/04/16.
//  Copyright © 2016 Miguel Santos. All rights reserved.
//

import UIKit

class DetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var txt_price: UITextField!
    @IBOutlet weak var picker_Category: UIPickerView!
    
    @IBOutlet weak var productListTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        productListTV.delegate = self
        productListTV.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveProduct(sender: AnyObject) {
        
        
    }
   
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allProducts.count
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("ProductDetailsCell", forIndexPath: indexPath) as? ProductDetailsCell {
            
            cell.configureCell(allProducts[indexPath.row])
            return cell
            
        } else {
            
            return ProductDetailsCell()
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
