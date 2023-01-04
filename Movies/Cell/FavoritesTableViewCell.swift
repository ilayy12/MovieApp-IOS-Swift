//
//  FavoritesTableViewCell.swift
//  Movies
//
//  Created by aytü on 27.07.2022.
//

import UIKit
import SwiftUI

class FavoritesTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    let imgPath = "https://image.tmdb.org/t/p/w500"
    var url: URL?
    var favedMovie: MovieDetails?
    var langCode = Lang.shared.langCode ?? "en"
    
    @IBAction func favButtonTapped(_ sender: UIButton) {
        FavoritePress.shared.press(sender: sender)
    }
    
    func setFav(with favedMovie: MovieDetails?){
        guard let favedMovie = favedMovie else {
            return
        }
        
        movieName.text = favedMovie.title
        
        if let moviePosterPath = favedMovie.posterPath {
            let newURL = imgPath + moviePosterPath
            url = URL(string: newURL)
            movieImage.kf.setImage(with: url)
        } else {
            movieImage.image = UIImage(named: "movieDefault")
        }
        if let id = favedMovie.id {
            if UDM.shared.isKeyPresentInUserDefaults(key: String(id)) != false {
                favButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                favButton.setImage(UIImage(systemName: "star.slash"), for: .normal)
            }
            favButton.titleLabel?.text = String(id)
            favButton.titleLabel?.isHidden = true
        }
    }
}
