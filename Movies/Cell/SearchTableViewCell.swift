//
//  SearchTableViewCell.swift
//  Movies
//
//  Created by aytü on 30.07.2022.
//

import UIKit
import Kingfisher

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var imgNameStack: UIStackView!
    @IBOutlet weak var rateDateStack: UIStackView!
    @IBOutlet weak var favButton: UIButton!
    
    var url: URL?
    let vote: String = "vote".localize()
    var icon: String = ""
    let imgPath = "https://image.tmdb.org/t/p/w500"
    
    @IBAction func favButtonTapped(_ sender: UIButton) {
        FavoritePress.shared.press(sender: sender)
    }
    
    func setMovie(with search: MovieDetailsTwo?) {
        
        guard let search = search else {
            return
        }
        
        movieName.text = search.title
        rate.text = vote+"\( search.voteAverage ?? 0)"
        date.text = search.releaseDate ?? "-"
        
        if let searchPosterPath = search.posterPath {
            let newURL = imgPath + searchPosterPath
            url = URL(string: newURL)
            movieImage.kf.setImage(with: url)
        } else {
            movieImage.image = UIImage(named: "movieDefault")
        }
        if let id = search.id {
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
        movieName.layer.cornerRadius = 15
        movieImage.layer.cornerRadius = 15
        date.layer.cornerRadius = 15
        rate.layer.cornerRadius = 15
        mainStack.layer.cornerRadius = 20
        imgNameStack.layer.cornerRadius = 20
        imgNameStack.layer.borderWidth = 2.0
        imgNameStack.layer.borderColor = UIColor.systemOrange.cgColor
        rateDateStack.layer.cornerRadius = 20
        rateDateStack.layer.borderWidth = 2.0
        rateDateStack.layer.borderColor = UIColor.systemOrange.cgColor
    }
}
