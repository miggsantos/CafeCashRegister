//
//  productVC.swift
//  CafeCashRegister
//
//  Created by Miguel Santos on 20/10/15.
//  Copyright © 2015 Miguel Santos. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var product: Product!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
        
    }
    
    func configureCell(product: Product) {
        self.product = product
        
        self.nameLbl.text = self.product.name
        //self.thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
        
    }
    
    
}
