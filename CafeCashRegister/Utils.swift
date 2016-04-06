//
//  Utils.swift
//  CafeCashRegister
//
//  Created by Miguel Santos on 03/04/16.
//  Copyright © 2016 Miguel Santos. All rights reserved.
//

import UIKit

func getDocumentsURL() -> NSURL {
    let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
    return documentsURL
}

func fileInDocumentsDirectory(filename: String) -> String {
    
    let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
    return fileURL.path!
    
}


