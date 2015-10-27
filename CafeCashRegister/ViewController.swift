//
//  ViewController.swift
//  CafeCashRegister
//
//  Created by Miguel Santos on 17/10/15.
//  Copyright © 2015 Miguel Santos. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var allProducts = [Product]()
    var filteredProducts = [Product]()
    var bagItems = [Product]()
    
    var runningNumber = ""
    let euroSymbol = " € "
    
    @IBOutlet weak var productsCV: UICollectionView!
    @IBOutlet weak var bagTV: UITableView!
    @IBOutlet weak var calculatorView: UIView!
    
    @IBOutlet weak var totalLbl: UILabel!
    
    @IBOutlet weak var calcDisplay: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        productsCV.delegate = self
        productsCV.dataSource = self
        bagTV.delegate = self
        bagTV.dataSource = self
        
        calculatorView.hidden = true
        productsCV.hidden = false
        
        allProducts.append(Product.init( productId: 1,name: "café", price: 0.55, category: Product.Category.CAFE ))
        allProducts.append(Product.init( productId: 2, name: "descafeinado", price: 0.45, category: Product.Category.CAFE))
        allProducts.append(Product.init( productId: 3, name: "carioca", price: 0.45, category: Product.Category.CAFE))
        allProducts.append(Product.init( productId: 4, name: "cerveja", price: 0.75, category: Product.Category.ALCOOL))
        allProducts.append(Product.init( productId: 5,name: "vinho", price: 0.35, category: Product.Category.ALCOOL ))
        
        filteredProducts = allProducts
        
    }
    
    
    @IBAction func changeCategory(sender: UIButton) {
        
        print(sender.tag)
        
        
        filteredProducts.removeAll(keepCapacity: false)
        
        filteredProducts = allProducts.filter({$0.category.rawValue == sender.tag })
        
        
        productsCV.reloadData()
        
        
    }
    
    
    
    @IBAction func calcNumberPressed(sender: UIButton) {
        
        if(sender.tag == -1){
            
            if !runningNumber.containsString(".") {
                runningNumber += "."
            }
            
            
        } else {
            runningNumber += "\(sender.tag)"
        }
        
        calcDisplay.text = runningNumber + euroSymbol
        
    }
    
    @IBAction func backspacePressed(sender: AnyObject) {
        
        runningNumber = String(runningNumber.characters.dropLast())
        calcDisplay.text = runningNumber + euroSymbol
    }
    
    @IBAction func addPressed(sender: AnyObject) {
        
        if let calcValue = Double(runningNumber)  {
        
            bagItems.append(Product.init( productId: 0,name: "valor manual", price: calcValue, category: Product.Category.TODOS ))
            
            bagTV.reloadData()
            showTotal()
            
            runningNumber = ""
            calcDisplay.text = euroSymbol
            
            
        } else {
            print("not double")
        }
        
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
    
    
    func showTotal(){
        
        let total:Double = calculateTotal()
        
        totalLbl.text = "Total: " + total.description + " €"
        
//        refreshTableView()
//        
//        
//        if(activeTrocoTag > 0){
//            showTroco( calcuclate_Troco(total) )
//        }
        
    }
    
    func calculateTotal() -> Double{
        var total = 0.0;
        for p in bagItems{
            total += (p.price * Double(p.quantity) )
        }
        return total
    }
    
    @IBAction func cleanBag(sender: AnyObject) {
        
        
//        for p in allProducts{
//            p.Quantity = 1
//        }
        
        bagItems.removeAll(keepCapacity: false)
        totalLbl.text = "0.0";
        
        //trocoLbl.text = "";
        //activeTrocoTag = 0
        //resetTrocoButtons()
        
        
        
        bagTV.reloadData()
    }
    
    
    /// ***** TableView *****
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bagItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("BagItemCell", forIndexPath: indexPath) as? BagItemCell {
            
            cell.configureCell(bagItems[indexPath.row])
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

            bagItems.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            showTotal()

        }
    }
    
    
    // ***** CollectionView *****
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
   
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProductCell", forIndexPath: indexPath) as? ProductCell {
            
            let p:Product!
            
            p = filteredProducts[indexPath.row]
            
            cell.configureCell(p)
            
            return cell
        
        } else {
        
            return UICollectionViewCell()
        }
        
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(105, 105)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let p:Product!
        
        p = filteredProducts[indexPath.row]
        
        if let index = bagItems.indexOf({$0.productId == p.productId}){
            bagItems[index].quantity++
        } else {
            bagItems.append(Product(productId: p.productId, name: p.name, price: p.price, category: p.category ))
        }

        
        bagTV.reloadData()
        showTotal()
    }

    
    
    

}

