//
//  MovieDetailsViewController.swift
//  Movies
//
//  Created by aytü on 28.07.2022.
//

import UIKit
import Alamofire
import Kingfisher
import SwiftUI

final class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var originalTitleTitle: UILabel!
    @IBOutlet weak var dateTitle: UILabel!
    @IBOutlet weak var runTimeTitle: UILabel!
    @IBOutlet weak var revenueTitle: UILabel!
    @IBOutlet weak var budgetTitle: UILabel!
    @IBOutlet weak var genresTitle: UILabel!
    @IBOutlet weak var overviewTitle: UILabel!
    @IBOutlet weak var prodCompTitle: UILabel!
    @IBOutlet weak var castTitle: UILabel!
    @IBOutlet weak var recTitle: UILabel!
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var favButton: UIButton! 
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieOriginalTitle: UILabel!
    
    @IBOutlet weak var homePageView: UITextView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var runTime: UILabel!
    @IBOutlet weak var revenue: UILabel!
    @IBOutlet weak var budget: UILabel!
    @IBOutlet weak var genresOne: UILabel!
    @IBOutlet weak var genresTwo: UILabel!
    @IBOutlet weak var genresThree: UILabel!
    @IBOutlet weak var overview: UILabel!
    
    @IBOutlet weak var nameStack: UIStackView!
    @IBOutlet weak var urlStack: UIStackView!
    @IBOutlet weak var infoStack: UIStackView!
    @IBOutlet weak var overviewStack: UIStackView!
    @IBOutlet weak var prodCompStack: UIStackView!
    @IBOutlet weak var castStack: UIStackView!
    @IBOutlet weak var recStack: UIStackView!
    
    @IBOutlet weak var recTableView: UITableView!
    @IBOutlet weak var compCollectionView: UICollectionView!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    private var details: MovieDetails?
    private var actors: [CastDetails?]?
    private var comps: [Companies?]?
    private var recs: [MovieDetailsTwo?]?
    
    var totalRec: Int?
    var totalPages: Int?
    var movieID: Int?
    var castID: String?
    var url: URL?
    var optUrl: String = "https://images.app.goo.gl/CGA5Z7D3rSi1maCy5"
    let imgPath = "https://image.tmdb.org/t/p/w500/"
    var langCode = Lang.shared.langCode ?? "en"
    var pageNo = 1
    
    static let shared = MovieDetailsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionViews()
        configureTableView()
        prepareView()
        fetch()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.reloadInputViews()
    }
    
    @IBAction func favButtonTapped(_ sender: UIButton) {
        FavoritePress.shared.press(sender: sender)
    }
    
    private func configureCollectionViews() {
        compCollectionView.delegate = self
        compCollectionView.dataSource = self
        compCollectionView.register(UINib(nibName: "ProductionCompCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductionCompCollectionViewCell")
        
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        castCollectionView.register(UINib(nibName: "CastCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CastCollectionViewCell")
    }
    
    private func configureTableView() {
        recTableView.delegate = self
        recTableView.dataSource = self
        recTableView.register(UINib(nibName: "RecommendationTableViewCell", bundle: nil), forCellReuseIdentifier: "RecommendationTableViewCell")
    }
    
    private func prepareView() {
        setCorner()
        self.title = "movieDetails".localize()
        originalTitleTitle.text = "originalTitle".localize()
        dateTitle.text = "date".localize()
        runTimeTitle.text = "runtime".localize()
        revenueTitle.text = "revenue".localize()
        budgetTitle.text = "budget".localize()
        genresTitle.text = "genres".localize()
        overviewTitle.text = "overview".localize()
        prodCompTitle.text = "prodComp".localize()
        castTitle.text = "cast".localize()
        recTitle.text = "recommendations".localize()
    }
    
    private func fetch() {
        DetailsInfo.shared.getDetails(lang: langCode, id: movieID ?? 0) { [self] result in
            switch result {
            case .success(let response):
                self.title = response.title
                self.details = response
                self.movieTitle.text = response.title
                self.movieOriginalTitle.text = response.originalTitle
                if response.releaseDate == nil {
                    self.date.text = "-"
                } else {
                    self.date.text = response.releaseDate
                }
                if let runtime = response.runtime {
                    self.runTime.text = String(describing: runtime)
                }else {
                    self.runTime.text = "-"
                }
                if let revenue = response.revenue {
                    self.revenue.text = "$"+String(describing: revenue)
                } else {
                    self.revenue.text = "-"
                }
                if let budget = response.budget {
                    self.budget.text = "$"+String(describing: budget)
                } else {
                    self.budget.text = "-"
                }
                if let genres = response.genres, genres.count > 0 {
                    if genres.count == 3 {
                        self.genresOne.text = genres[0]?.name
                        self.genresTwo.text = genres[1]?.name
                        self.genresThree.text = genres[2]?.name
                    } else if genres.count == 2 {
                        self.genresOne.text = genres[0]?.name
                        self.genresTwo.text = genres[1]?.name
                    } else {
                        self.genresTitle.text = "genre".localize()
                        self.genresOne.text = genres[0]?.name
                    }
                } else {
                    self.genresTitle.text = ""
                }
                if response.overview == nil {
                    overviewStack.isHidden = true
                } else {
                    self.overview.text = response.overview
                }
                if let homepage = response.homepage, !homepage.isEmpty {
                    self.homePageView.text = homepage
                } else {
                    self.homePageView.text = "homePageCNBF".localize()
                }
                if response.posterPath == nil {
                    self.url = URL(string: "https://images.app.goo.gl/6v5X1ofbS125rmXw8")
                } else {
                    let newURL = self.imgPath + (response.posterPath)!
                    self.url = URL(string: newURL)
                }
                self.movieImage.kf.setImage(with: self.url!)
                if let companies = response.productionCompanies {
                    self.comps = companies
                    self.compCollectionView.reloadData()
                } else {
                    self.compCollectionView.isHidden = true
                }
                if let id = response.id {
                    if UDM.shared.isKeyPresentInUserDefaults(key: String(id)) != false {
                        favButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                    } else {
                        favButton.setImage(UIImage(systemName: "star.slash"), for: .normal)
                    }
                    favButton.titleLabel?.text = String(id)
                    favButton.titleLabel?.isHidden = true
                }
            case .failure:
                return
            }
            
            CastInfo.shared.getCast(lang: self.langCode, id: self.movieID ?? 0 ) { result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.actors = response.cast
                        self.castCollectionView.reloadData()
                    }
                case .failure:
                    self.castCollectionView.isHidden = true
                }
            }
            
            RecsInfo.shared.getRecs(lang: self.langCode, pagination: false, id: self.movieID ?? 0, pageNo: self.pageNo) {
                result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.recs = response.results
                        self.totalRec = response.totalResults
                        self.totalPages = response.totalPages
                        self.recTableView.reloadData()
                    }
                case .failure:
                    self.recTableView.isHidden = true
                }
            }
        }
    }
    
    private func paginationFetch() {
        MoviesPopular.shared.getMoviePopular(lang: langCode, pagination: true, pageNo: pageNo) { result in
            DispatchQueue.main.async {
                self.recTableView.tableFooterView = nil
            }
            switch result {
            case .success(let response):
                if let results = response.results {
                    self.recs?.append(contentsOf: results)
                }
                self.totalRec = response.totalResults
                self.totalPages = response.totalPages
                DispatchQueue.main.async {
                    self.recTableView.reloadData()
                }
            case .failure:
                return
            }
        }
    }
    
    func setCorner() {
        self.movieImage.layer.cornerRadius = 10
        nameStack.layer.cornerRadius = 15
        urlStack.layer.cornerRadius = 15
        infoStack.layer.cornerRadius = 15
        infoStack.layer.borderColor = UIColor.purple.cgColor
        infoStack.layer.borderWidth = 3.0
        overviewStack.layer.cornerRadius = 15
        overviewStack.layer.borderColor = UIColor.purple.cgColor
        overviewStack.layer.borderWidth = 2.0
        prodCompStack.layer.cornerRadius = 15
        prodCompStack.layer.borderColor = UIColor.systemOrange.cgColor
        prodCompStack.layer.borderWidth = 2.0
        castStack.layer.cornerRadius = 15
        castStack.layer.borderColor = UIColor.systemOrange.cgColor
        castStack.layer.borderWidth = 2.0
        recStack.layer.cornerRadius = 15
        recStack.layer.borderColor = UIColor.systemOrange.cgColor
        recStack.layer.borderWidth = 2.0
    }
}

//MARK: - CollectionView Extension

extension MovieDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == compCollectionView {
            return comps?.count ?? 0
        } else {
            return actors?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == compCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductionCompCollectionViewCell", for: indexPath) as? ProductionCompCollectionViewCell else {
                return UICollectionViewCell()
            }
            let company = comps?[indexPath.row]
            cell.setComp(with: company)
            cell.setCorners()
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCollectionViewCell", for: indexPath) as? CastCollectionViewCell else {
                return UICollectionViewCell()
            }
            let actor = actors?[indexPath.row]
            cell.setActor(with: actor)
            cell.setCorner()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == castCollectionView {
            guard let castDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: String(describing: CastDetailsViewController.self)) as? CastDetailsViewController else {
                return
            }
            castDetailsViewController.castID = actors?[indexPath.item]?.id ?? 0
            self.navigationController?.pushViewController(castDetailsViewController, animated: true)
        } else {
            return
        }
    }
}


//MARK: - TableView Extension

extension MovieDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recs?.count ?? 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendationTableViewCell", for: indexPath) as? RecommendationTableViewCell else {
            return UITableViewCell()
        }
        let singleRec = recs?[indexPath.row]
        cell.setCorners()
        cell.setRec(with: singleRec)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movieDetailsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: String(describing: MovieDetailsViewController.self)) as? MovieDetailsViewController else {
            return
        }
        movieDetailsController.movieID = recs?[indexPath.row]?.id
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(movieDetailsController, animated: true)
        }
    }
}

//MARK: - ScrollView Extension

extension MovieDetailsViewController: UIScrollViewDelegate {
    private func createSpinnerFooter() -> UIView{
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == recTableView {
            let position = scrollView.contentOffset.y
            if position > (recTableView.contentSize.height - 100 - scrollView.frame.size.height) {
                guard !MoviesPopular.shared.ispagination else { //allready updating
                    return
                }
                self.recTableView.tableFooterView = createSpinnerFooter()
                self.pageNo += 1
                if self.pageNo <= self.totalPages ?? 4 {
                    paginationFetch()
                }
            }
        }
    }
}
