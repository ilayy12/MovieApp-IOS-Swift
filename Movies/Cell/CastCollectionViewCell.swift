//
//  CastCollectionViewCell.swift
//  Movies
//
//  Created by aytü on 2.08.2022.
//

import UIKit
import Kingfisher

class CastCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var actorImage: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var imgStack: UIStackView!
    @IBOutlet weak var actorName: UILabel!
    
    let imgPath = "https://image.tmdb.org/t/p/w500"
    
    func setActor(with anActor: CastDetails?) {
         
        guard let anActor = anActor else {
            return
        }

        actorName.text = anActor.name
        characterName.text = anActor.character

        if let profilePath = anActor.profilePath {
            let newURL = imgPath + profilePath
            actorImage.kf.setImage(with: URL(string: newURL))
        } else {
            if anActor.gender == 1 {
                actorImage.image = UIImage(named: "womanDefault")
            }
        }
    }
    
    func setCorner() {
        imgStack.layer.cornerRadius = 10
    }
}
