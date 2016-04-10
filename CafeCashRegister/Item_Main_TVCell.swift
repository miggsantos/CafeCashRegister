//
//  Item_Main_TVCell.swift
//  CafeCashRegister
//
//  Created by Miguel Santos on 09/04/16.
//  Copyright © 2016 Miguel Santos. All rights reserved.
//

import UIKit

class Item_Main_TVCell: UITableViewCell {

    @IBOutlet weak var thumbImg: UIImageView!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(item: AddedItem) {
        self.name.text = item.nameAndQty
        self.price.text = item.priceWithCurrency
        self.thumbImg.image = UIImage(named: "cafe")
        //self.thumbImg.layer.cornerRadius = 5.0
        
    }

}
