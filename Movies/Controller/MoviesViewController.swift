//
//  ViewController.swift
//  Movies
//
//  Created by aytü on 26.07.2022.
//

import UIKit

final class MoviesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies: [MovieDetailsTwo?]?
    var movieID: Int?
    var totalMovies: Int?
    var totalPages: Int?
    var langCode = Lang.shared.langCode ?? "en"
    var pageNo = 1
    
    static let shared = MoviesViewController()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        prepareView()
        fetch()
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: String(describing: MovieTableViewCell.self), bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
    }
    
    private func prepareView() {
        self.title = "movies".localize()
    }
    
    private func fetch() {
        MoviesPopular.shared.getMoviePopular(lang: langCode, pagination: false, pageNo: pageNo) { result in
            switch result {
            case .success(let response):
                self.movies = response.results
                self.totalMovies = response.totalResults
                self.totalPages = response.totalPages
                self.tableView.reloadData()
            case .failure:
                return
            }
        }
    }
}

//MARK: - TableView Extension

extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        let singleMovie = movies?[indexPath.item]
        cell.setCorners()
        cell.setMovie(with: singleMovie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movieDetailsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: String(describing: MovieDetailsViewController.self)) as? MovieDetailsViewController else {
            return
        }
        movieDetailsController.movieID = movies?[indexPath.row]?.id
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(movieDetailsController, animated: true)
        }
    }
}

//MARK: -  ScrollView & Reloading Extension

extension MoviesViewController: UIScrollViewDelegate {
    private func createSpinnerFooter() -> UIView{
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
            guard !MoviesPopular.shared.ispagination else { //allready updating
                return
            }
            self.tableView.tableFooterView = createSpinnerFooter()
            self.pageNo += 1
            if self.pageNo <= self.totalPages ?? 4 {
                MoviesPopular.shared.getMoviePopular(lang: langCode, pagination: true, pageNo: pageNo) { result in
                    DispatchQueue.main.async {
                        self.tableView.tableFooterView = nil
                    }
                    switch result {
                    case .success(let response):
                        self.movies?.append(contentsOf: response.results!) //sonra düzenlenecek
                        self.totalMovies = response.totalResults
                        self.totalPages = response.totalPages
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    case .failure:
                        return
                    }
                }
            }
        }
    }
}
