//
//  bagItemCellTableViewCell.swift
//  CafeCashRegister
//
//  Created by Miguel Santos on 22/10/15.
//  Copyright © 2015 Miguel Santos. All rights reserved.
//

import UIKit

class BagItemCell: UITableViewCell {

    
    @IBOutlet weak var thumbImg: UIImageView!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCell(product: Product) {
        self.name.text = product.nameAndQty
        self.price.text = product.priceStr
        self.thumbImg.image = UIImage(named: product.image)
        self.thumbImg.layer.cornerRadius = 5.0
        
    }
    
    

}
