//
//  Item.swift
//  CafeCashRegister
//
//  Created by Miguel Santos on 07/04/16.
//  Copyright © 2016 Miguel Santos. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class Item: NSManagedObject {

    func setValues(name:String, price:NSNumber, itemType: ItemType ){
        self.created = NSDate()
        self.name = name
        self.price = price
        self.itemtype = itemType
    }
    
    
    
    func setItemImage(image: UIImage){
        let data = UIImagePNGRepresentation(image)
        self.image = data
    }
    
    func getItemImg() -> UIImage {
        
        if let imageData = self.image {
        
            let img = UIImage(data: imageData)
            return img!
        } else {
        
            return UIImage(named: "calc.png")!
        }
        

    }
    
}
