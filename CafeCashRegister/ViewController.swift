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
    
    
    @IBOutlet weak var productsCV: UICollectionView!
    @IBOutlet weak var bagTV: UITableView!
    
    @IBOutlet weak var totalLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        productsCV.delegate = self
        productsCV.dataSource = self
        bagTV.delegate = self
        bagTV.dataSource = self
        
        allProducts.append(Product.init( productId: 1,name: "café", price: 0.55 ))
        allProducts.append(Product.init( productId: 2, name: "descafeinado", price: 0.45))
        allProducts.append(Product.init( productId: 3, name: "carioca", price: 0.45))
        allProducts.append(Product.init( productId: 4, name: "cerveja", price: 0.75))
        allProducts.append(Product.init( productId: 5,name: "vinho", price: 0.35 ))
        
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
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allProducts.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
   
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProductCell", forIndexPath: indexPath) as? ProductCell {
            
            let p:Product!
            
            p = allProducts[indexPath.row]
            
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
        
        p = allProducts[indexPath.row]
        
        if let index = bagItems.indexOf({$0.productId == p.productId}){
            bagItems[index].quantity++
        } else {
            bagItems.append(Product(productId: p.productId, name: p.name, price: p.price))
        }

        
        bagTV.reloadData()
        showTotal()
    }

    
    
    

}

