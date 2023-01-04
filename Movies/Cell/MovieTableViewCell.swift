//
//  TableViewCell.swift
//  Movies
//
//  Created by aytü on 27.07.2022.
//

import UIKit
import Kingfisher
import SwiftUI

class MovieTableViewCell: UITableViewCell {
  
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var favoriteB: UIButton!
    @IBOutlet weak var mainStack: UIStackView!
    
    let vote: String = "vote".localize()
    var icon: String = ""
    let imgPath = "https://image.tmdb.org/t/p/w500"
    var url: URL?
    var buttonTap: Bool?
    
    @IBAction func favoriteButton(_ sender: UIButton) {
        FavoritePress.shared.press(sender: sender)
    }
    
    func setMovie(with movie: MovieDetailsTwo?) {
        
        guard let movie = movie else {
            return
        }

        movieName.text = movie.title
        rate.text = vote+"\( movie.voteAverage ?? 0)"
        date.text = movie.releaseDate ?? "-"
        
        if let moviePosterPath = movie.posterPath {
            let newURL = imgPath + moviePosterPath
            url = URL(string: newURL)
            movieImage.kf.setImage(with: url)
        } else {
            movieImage.image = UIImage(named: "movieDefault")
        }
        if let id = movie.id {
            if UDM.shared.isKeyPresentInUserDefaults(key: String(id)) != false {
                favoriteB.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                favoriteB.setImage(UIImage(systemName: "star.slash"), for: .normal)
            }
            favoriteB.titleLabel?.text = String(id)
            favoriteB.titleLabel?.isHidden = true
        }
    }
    
    func setCorners() {
        mainStack.layer.cornerRadius = 20
        movieImage.layer.cornerRadius = 10
        movieName.layer.cornerRadius = 10
        rate.layer.cornerRadius = 10
        date.layer.cornerRadius = 10
    }
}
