//
//  Product.swift
//  CafeCashRegister
//
//  Created by Miguel Santos on 20/10/15.
//  Copyright © 2015 Miguel Santos. All rights reserved.
//

import Foundation

class Product {

    
    enum Category: Int{
    
        case todos = 0,
        cafe,
        bebidas,
        alcool,
        comer,
        tabaco
    }
    
    
    fileprivate var _productId:Int!
    fileprivate var _name:String!
    fileprivate var _price:Double!
    fileprivate var _image:String!
    fileprivate var _quantity:Int!
    fileprivate var _category:Category!
    
    var productId: Int {
        return _productId
    }
    var name: String {
        get{ return _name.capitalized }
        set{ _name = newValue }
        
    }
    
    
    var nameAndQty: String {
        
        if(quantity > 1) {
        
            return _name.capitalized + " \(quantity)x"
        }
        else {
            return _name.capitalized
        
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
        return "\(self.price) \(EURO)"
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
    
    var image: String {
        get{
            if _image == nil {
                return "cafe.png"
            }
            return _image
        }
        set{ _image = newValue }
    }
    
    var category: Category {
        return _category
    }

    init(name: String, price:Double ) {
        self._name = name
        self._price = price
    }
    
    init(productId: Int ,name: String, price:Double, category:Category ) {
        self._name = name
        self._productId = productId
        self._price = price
        self._category = category
    }
    
    
    init(productId: Int ,name: String, price:Double, category:Category, image: String ) {
        self._name = name
        self._productId = productId
        self._price = price
        self._category = category
        self._image = image
    }

    
    
}
