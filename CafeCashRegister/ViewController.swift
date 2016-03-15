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
    
    let activeBillColor = UIColor(red: 36/255, green: 131/255, blue: 192/255, alpha: 255)
    let notActiveBillColor = UIColor(red: 46/255, green: 174/255, blue: 255/255, alpha: 255)
    var activeBillTag = 0
    
    
    @IBOutlet weak var productsCV: UICollectionView!
    @IBOutlet weak var bagTV: UITableView!
    @IBOutlet weak var calculatorView: UIView!
    
    @IBOutlet weak var totalLbl: UILabel!
    
    @IBOutlet weak var calcDisplay: UILabel!
    
    
    @IBOutlet weak var bill5: UIButton!
    @IBOutlet weak var bill10: UIButton!
    @IBOutlet weak var bill20: UIButton!
    @IBOutlet weak var bill50: UIButton!
    @IBOutlet weak var changeLbl: UILabel!
    
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
        
        changeLbl.text = ""
        resetBillButtons()
        
    }
    
    
    @IBAction func changeCategory(sender: UIButton) {
        
        print(sender.tag)
        

        filteredProducts.removeAll(keepCapacity: false)
        
        if(sender.tag > 0){
        
            filteredProducts = allProducts.filter({$0.category.rawValue == sender.tag })
        }
        else {
        
            filteredProducts = allProducts
        }
        

        //productsCV.reloadData()

  
        self.calculatorView.hidden = true
        self.productsCV.hidden = false
        
        
        
        
        
        dispatch_async(dispatch_get_main_queue(), {
            
            
            self.productsCV.reloadData()
            
        
        })
        



    }
    
    // *************************
    // ****** Calculator *******
    // *************************
    
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
        
            bagItems.append(Product.init( productId: 0,name: "valor manual", price: calcValue, category: Product.Category.TODOS, image: "euro.png" ))
            
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
            changeLbl.text = change.description + " €"
        }
    }
    
    
    func showTotal(){
        
        let total:Double = calculateTotal()
        
        totalLbl.text = "Total: " + total.description + " €"
        
        if(activeBillTag > 0){
            showChange( calculateChange(total) )
        }
        
    }
    
    func calculateTotal() -> Double{
        var total = 0.0;
        for p in bagItems{
            total += (p.price * Double(p.quantity) )
        }
        return total
    }
    
    @IBAction func cleanBag(sender: AnyObject) {
        
        bagItems.removeAll(keepCapacity: false)
        totalLbl.text = "0.0";
        
        
        changeLbl.text = "";
        activeBillTag = 0
        resetBillButtons()

        bagTV.reloadData()
    }
    
    // **************************
    // ******* TableView ********
    // **************************
    
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
    
    // **************************
    // ***** CollectionView *****
    // **************************
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        self.productsCV.collectionViewLayout.invalidateLayout()
        
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProductCell", forIndexPath: indexPath) as? ProductCell {
            
            let p:Product!
            print("row= \(indexPath.row)")
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

