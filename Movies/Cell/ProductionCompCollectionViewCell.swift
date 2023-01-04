//
//  ProductionCompCollectionViewCell.swift
//  Movies
//
//  Created by aytü on 31.07.2022.
//

import UIKit
import Kingfisher

class ProductionCompCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var compIcon: UIImageView!
    @IBOutlet weak var compName: UILabel!
    @IBOutlet weak var compCountry: UILabel!
    @IBOutlet weak var compNameStack: UIStackView!
    
    let imgPath = "https://image.tmdb.org/t/p/w500"
    
    func setComp(with comp: Companies?){
        
        guard let comp = comp else {
            return
        }
        
        compName.text = comp.name
        compCountry.text = comp.originCountry
        
        if let logoPath = comp.logoPath {
            let newURL = imgPath + logoPath
            compIcon.kf.setImage(with: URL(string: newURL))
        }
    }
    
    func setCorners() {
        compNameStack.layer.cornerRadius = 15
        compNameStack.layer.borderWidth = 2.0
        compNameStack.layer.borderColor = UIColor.systemPurple.cgColor
    }
}
