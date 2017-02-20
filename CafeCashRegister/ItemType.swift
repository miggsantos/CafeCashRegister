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

    func setValues(_ type:String){
        self.created = Date()
        self.type = type
    }

    
}
