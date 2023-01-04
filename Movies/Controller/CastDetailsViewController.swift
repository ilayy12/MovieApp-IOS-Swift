//
//  CastDetailsViewController.swift
//  Movies
//
//  Created by aytü on 28.07.2022.
//

import UIKit
import Kingfisher

final class CastDetailsViewController: UIViewController {

    @IBOutlet weak var actorImg: UIImageView!
    @IBOutlet weak var actorName: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var deathday: UILabel!
    @IBOutlet weak var placeOfBirth: UILabel! 
    @IBOutlet weak var biography: UILabel! 
    @IBOutlet weak var imgNameStack: UIStackView!
    @IBOutlet weak var biographyTitle: UILabel!
    @IBOutlet weak var placeOfBirthTitle: UILabel!
    
    var castID: Int = 0
    let imgPath = "https://image.tmdb.org/t/p/w500"
    var langCode = Lang.shared.langCode ?? "en"
    
    static var shared = CastDetailsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        fetch()
        setCorners()
    }
    
    private func prepareView() {
        self.title = "castDetails".localize()
        self.biographyTitle.text = "biography".localize()
        self.placeOfBirthTitle.text = "birthPlace".localize()
    }
    
    private func fetch() {
        CastDetailsInfo.shared.getCastDetails(lang: langCode, id: castID) { result in
            switch result {
            case .success(let response):
                self.actorName.text = response.name
                if let birthday = response.birthday {
                    self.birthday.text = birthday
                } else {
                    self.birthday.text = "-"
                }
                if let deathday = response.deathday {
                    self.deathday.text = deathday
                } else {
                    self.deathday.text = "-"
                }
                if let placeOfBirth = response.placeOfBirth {
                    self.placeOfBirth.text = placeOfBirth
                } else {
                    self.placeOfBirth.text = "-"
                }
                if let profilePath = response.profilePath {
                    let newURL = self.imgPath + profilePath
                    self.actorImg.kf.setImage(with: URL(string: newURL))
                } else {
                    if response.gender == 1 {
                        self.actorImg.image = UIImage(systemName: "womanDefault")
                    }
                }
                if let biography = response.biography {
                    self.biography.text = biography
                } else {
                    self.biography.text = ""
                    self.biographyTitle.text = ""
                }
            case .failure:
                return
            }
        }
    }
    
    func setCorners() {
        imgNameStack.layer.cornerRadius = 20
        actorImg.layer.cornerRadius = 10
        actorName.layer.cornerRadius = 10
        birthday.layer.cornerRadius = 10
        deathday.layer.cornerRadius = 10
        placeOfBirth.layer.cornerRadius = 10
        biography.layer.cornerRadius = 10
    }
}
