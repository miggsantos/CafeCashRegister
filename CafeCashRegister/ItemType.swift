//
//  ItemType.swift
//  CafeCashRegister
//
//  Created by Miguel Santos on 07/04/16.
//  Copyright © 2016 Miguel Santos. All rights reserved.
//

import Foundation
import CoreData

enum Type:String {
    case Cafe
    case Bebida
    case Alcool
    case Comer
    case Tabaco
}

class ItemType: NSManagedObject {

    
// Insert code here to add functionality to your managed object subclass

    func setValues(type:String){
        self.created = NSDate()
        self.type = type
    }
    
    
//    func setValues(type:Type){
//        self.created = NSDate()
//        self.type = type.rawValue
//    }
    
}
