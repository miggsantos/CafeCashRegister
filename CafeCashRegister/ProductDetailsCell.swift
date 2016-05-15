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
    
    var item: Item!
    
    func configureCell(item: Item) {
        self.item = item
        self.nameLbl.text = self.item.name
        self.priceLbl.text = self.item.price!.description
        self.thumbImg.image = self.item.getItemImg()
        
        //self.thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
        
    }

}
