//
//  File.swift
//  CafeCashRegister
//
//  Created by Miguel Santos on 04/09/16.
//  Copyright © 2016 Miguel Santos. All rights reserved.
//

import UIKit

extension UITableViewCell {
    func setTransparent() {
        let bgView: UIView = UIView()
        bgView.backgroundColor = .clearColor()
        
        self.backgroundView = bgView
        self.backgroundColor = .clearColor()
    }
}