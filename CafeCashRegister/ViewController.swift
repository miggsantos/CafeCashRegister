//
//  ViewController.swift
//  CafeCashRegister
//
//  Created by Miguel Santos on 17/10/15.
//  Copyright © 2015 Miguel Santos. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //var allProducts = [Product]()
    //var filteredProducts = [Product]()
    //var bagItems = [Product]()
    
    //var runningNumber = ""
    
    @IBOutlet weak var productsCV: UICollectionView!

    @IBOutlet weak var calculatorView: CalculatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        productsCV.delegate = self
        productsCV.dataSource = self

        
        calculatorView.hidden = true
        productsCV.hidden = false
        
        addTestData()
        

        
        filteredProducts = allProducts
        
    
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
        

  

        dispatch_async(dispatch_get_main_queue(), {
    })
        
        
        
        self.productsCV.collectionViewLayout.invalidateLayout()
        self.productsCV.reloadData()

        self.calculatorView.hidden = true
        self.productsCV.hidden = false

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
            //print("row= \(indexPath.row)")
            p = filteredProducts[indexPath.row]
            
            cell.configureCell(p)
            
            return cell
        
        } else {
            return UICollectionViewCell()
        }
    }

    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(117, 117)
    }
    
  
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let p:Product!
        
        p = filteredProducts[indexPath.row]
        
        if let index = bagItems.indexOf({$0.productId == p.productId}){
            bagItems[index].quantity += 1
        } else {
            bagItems.append(Product(productId: p.productId, name: p.name, price: p.price, category: p.category ))
        }
        
        refreshTableView()
    }
    
    
    
    
    func refreshTableView(){
        
        NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil)
    }
    
    func addTestData(){
        allProducts.append(Product.init( productId: 1,name: "café", price: 0.55, category: Product.Category.CAFE ))
        allProducts.append(Product.init( productId: 2, name: "descafeinado", price: 0.45, category: Product.Category.CAFE))
        allProducts.append(Product.init( productId: 3, name: "carioca", price: 0.45, category: Product.Category.CAFE))
        allProducts.append(Product.init( productId: 4, name: "cerveja", price: 0.75, category: Product.Category.ALCOOL))
        allProducts.append(Product.init( productId: 5,name: "vinho", price: 0.35, category: Product.Category.ALCOOL ))
        allProducts.append(Product.init( productId: 6,name: "chá", price: 0.55, category: Product.Category.CAFE ))
        allProducts.append(Product.init( productId: 7, name: "pastilhas", price: 0.45, category: Product.Category.COMER))
        allProducts.append(Product.init( productId: 8, name: "batatas fritas 0.80", price: 0.45, category: Product.Category.COMER))
        allProducts.append(Product.init( productId: 9, name: "coca-cola", price: 0.75, category: Product.Category.BEBIDAS))
        allProducts.append(Product.init( productId: 10,name: "sumol", price: 0.35, category: Product.Category.BEBIDAS ))
    }

}

