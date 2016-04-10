//
//  ItemCell_CV.swift
//  CafeCashRegister
//
//  Created by Miguel Santos on 08/04/16.
//  Copyright © 2016 Miguel Santos. All rights reserved.
//

import UIKit

class ItemCell_CV: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    func configureCell(item: Item) {

        
        self.nameLbl.text = item.name
        //self.thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
        
    }
}
