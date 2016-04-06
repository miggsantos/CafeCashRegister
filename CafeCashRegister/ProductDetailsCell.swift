//
//  ProductDetailsCell.swift
//  CafeCashRegister
//
//  Created by Miguel Santos on 07/04/16.
//  Copyright © 2016 Miguel Santos. All rights reserved.
//

import UIKit

class ProductDetailsCell: UITableViewCell {

    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    var product: Product!
    
    func configureCell(product: Product) {
        self.product = product
        self.nameLbl.text = self.product.name
        self.priceLbl.text = self.product.price.description
        
        //self.thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
        
    }

}
