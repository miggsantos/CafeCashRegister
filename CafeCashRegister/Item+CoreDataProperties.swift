//
//  Item+CoreDataProperties.swift
//  CafeCashRegister
//
//  Created by Miguel Santos on 10/04/16.
//  Copyright © 2016 Miguel Santos. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Item {

    @NSManaged var name: String?
    @NSManaged var price: NSNumber?
    @NSManaged var image: NSData?
    @NSManaged var itemtype: ItemType?

}
