//
//  Product.swift
//  CafeCashRegister
//
//  Created by Miguel Santos on 20/10/15.
//  Copyright © 2015 Miguel Santos. All rights reserved.
//

import Foundation

class Product {

    private var _productId:Int!
    private var _name:String!
    private var _price:Double!
    private var _image:String!
    private var _quantity:Int!
    
    var productId: Int {
        return _productId
    }
    var name: String {
        get{ return _name.capitalizedString }
        set{ _name = newValue }
        
    }
    
    
    var nameAndQty: String {
        
        if(quantity > 1) {
        
            return _name.capitalizedString + " \(quantity)x"
        }
        else {
            return _name.capitalizedString
        
        }
    }
    
    
    var price: Double {
        get{
            if _price == nil {
                return 0.0
            }
            return _price
        }
        set{ _price = newValue }
    }
    
    var priceStr: String {
        return "\(self.price) €"
    }
    
    var quantity: Int {
        get{
            if _quantity == nil {
                return 1
            }
            return _quantity
        }
        set{ _quantity = newValue }
    }
    

    init(productId: Int ,name: String, price:Double ) {
        self._name = name
        self._productId = productId
        self._price = price
    }
    
    
    
    
    
    
//    enum Category: Int{
//        
//        case TODOS = 0,
//        CAFE,
//        BEBIDAS,
//        ALCOOL,
//        COMER,
//        TABACO
//        
//    }
//    
//    var Id : Int?
//    var CategoryId : Category
//    
//    var Image : UIImage?
// 
//    
//    var Quantity : Int = 1
//    
//    
//    
//    init(id:Int, categoryId:Category, name:String, price:Double, imagePath:String) {
//        
//        self.Id = id
//        self.CategoryId = categoryId
//        self.Name = name
//        self.Price = price
//        self.Image = UIImage(named: imagePath)
//        
//    }
    
    
    
}