//
//  RecommendationTableViewCell.swift
//  Movies
//
//  Created by aytü on 31.07.2022.
//

import UIKit
import Kingfisher

class RecommendationTableViewCell: UITableViewCell {

    @IBOutlet weak var recMovieName: UILabel!
    @IBOutlet weak var recMovieImg: UIImageView!
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var favButton: UIButton!
    
    var url: URL?
    let imgPath = "https://image.tmdb.org/t/p/w500"
    
    @IBAction func favButtonTapped(_ sender: UIButton) {
        FavoritePress.shared.press(sender: sender)
    }
    
    func setRec(with recs: MovieDetailsTwo?) {
        
        guard let recs = recs else {
            return
        }
        
        recMovieName.text = recs.title
        
        if let recsPosterPath = recs.posterPath {
            let newURL = imgPath + recsPosterPath
            url = URL(string: newURL)
            recMovieImg.kf.setImage(with: url)
        } else {
            recMovieImg.image = UIImage(named: "movieDefault")
        }
        if let id = recs.id {
            if UDM.shared.isKeyPresentInUserDefaults(key: String(id)) != false {
                favButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                favButton.setImage(UIImage(systemName: "star.slash"), for: .normal)
            }
            favButton.titleLabel?.text = String(id)
            favButton.titleLabel?.isHidden = true
        }
    }
    
    func setCorners() {
        mainStack.layer.cornerRadius = 5
    }
}
