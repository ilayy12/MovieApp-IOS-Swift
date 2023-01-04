//
//  FavoritesViewController.swift
//  Movies
//
//  Created by aytü on 27.07.2022.
//

import UIKit
import SwiftUI

final class FavoritesViewController: UIViewController {
        
    @IBOutlet weak var favTable: UITableView!
    @IBOutlet weak var viewEmptyLabel: UILabel!
    
    let dispatchGroup = DispatchGroup()
    var favs: [MovieDetails?] = []
    var favIDs: [String] = []
    var langCode = Lang.shared.langCode ?? "en"
    var count = 0
    
    static let shared = FavoritesViewController()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        prepareView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setDatas()
    }
    
    private func configureTableView() {
        favTable.delegate = self
        favTable.dataSource = self
        favTable.register(UINib(nibName: "FavoritesTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoritesTableViewCell")
    }
    
    private func prepareView() {
        title = "favorites".localize()
    }
        
    private func setDatas() {
        UDM.shared.reachKeys()
        setFavIDs()
        if favIDs.count > 0 {
            fetch()
        } else {
            favTable.reloadData()
        }
    }
    
    private func setFavIDs() {
        if favIDs.isEmpty == false {
            favIDs.removeAll()
        }
        favIDs = UDM.shared.favs
    }
    
    private func fetch() {
        if favs.isEmpty == false {
            favs.removeAll()
        }
        for id in favIDs {
            guard let id = Int(id) else {
                return
            }
            dispatchGroup.enter()
            fetchFromAPI(movieID: id)
            dispatchGroup.leave()
        }
    }
    
    private func fetchFromAPI(movieID: Int) {
        DetailsInfo.shared.getDetails(lang: langCode, id: movieID) { result in
            switch result {
            case .success(let response):
                self.favs.append(response)
                if self.favs.count == self.favIDs.count {
                    self.favTable.reloadData()
                }
            case .failure:
                return
            }
        }
    }
}

// MARK: - Tableview Extension

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if favIDs.count > 0 && favs.count > 0 {
            count = favIDs.count
            viewEmptyLabel.isHidden = true
            favTable.isHidden = false
        } else {
            viewEmptyLabel.text = "noFavorited".localize()
            viewEmptyLabel.isHidden = false
            favTable.isHidden = true
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell", for: indexPath) as? FavoritesTableViewCell else {
            return UITableViewCell()
        }
        let movie = self.favs[indexPath.row]
        cell.setFav(with: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movieDetailsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: String(describing: MovieDetailsViewController.self)) as? MovieDetailsViewController else {
            return
        }
        guard let id = Int(favIDs[indexPath.row]) else {
            return
        }
        movieDetailsController.movieID = id
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(movieDetailsController, animated: true)
        }
    }
}
