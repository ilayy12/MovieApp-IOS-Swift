//
//  SearchViewController.swift
//  Movies
//
//  Created by aytü on 30.07.2022.
//

import UIKit

final class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTable: UITableView!

    let searchController = UISearchController()
    var searchs: [MovieDetailsTwo?]?
    var timer: Timer?
    var movieID: Int?
    var totalResults: Int?
    var totalPages: Int?
    var langCode = Lang.shared.langCode ?? "en"
    var searchedText: String = "nil"
    var pageNo = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        prepareView()
        prepareNavigationCont()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchTable.reloadData()
    }
    
    private func configureTableView() {
        searchTable.delegate = self
        searchTable.dataSource = self
        searchTable.register(UINib(nibName: String(describing: SearchTableViewCell.self), bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
    }
    
    private func prepareView() {
        self.title = "search".localize()
    }
    
    private func prepareNavigationCont() {
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "searchPlaceholder".localize()
        searchController.searchBar.delegate = self
    }
    
    @objc func fetch() {
        SearchedInfo.shared.getSearched(lang: langCode, pagination: false, pageNo: pageNo, query: self.searchedText) { result in
            switch result {
            case .success(let response):
                self.searchs = response.results
                self.totalResults = response.totalResults
                self.totalPages = response.totalPages
                DispatchQueue.main.async {
                    self.searchTable.reloadData()
                }
            case .failure:
                return
            }
        }
    }
    
    private func paginationFetch() {
        SearchedInfo.shared.getSearched(lang: langCode, pagination: true, pageNo: pageNo, query: searchedText) { result in
            DispatchQueue.main.async {
                self.searchTable.tableFooterView = nil
            }
            switch result {
            case .success(let response):
                if let results = response.results {
                    self.searchs?.append(contentsOf: results)
                }
                self.totalResults = response.totalResults
                self.totalPages = response.totalPages
                DispatchQueue.main.async {
                    self.searchTable.reloadData()
                }
            case .failure:
                return
            }
        }
    }
}

//MARK: - SearchBar Extension

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        self.searchedText = searchText.replacingOccurrences(of: " ", with: "%20").lowercased()
        if searchedText.count >= 3 {
            pageNo = 1
            timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(fetch) , userInfo: nil, repeats: false)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchs?.removeAll()
        searchTable.reloadData()
    }
}

//MARK: - TableView Extension

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        let singleMovie = searchs?[indexPath.item]
        cell.setCorners()
        cell.setMovie(with: singleMovie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movieDetailsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: String(describing: MovieDetailsViewController.self)) as? MovieDetailsViewController else {
            return
        }
        movieDetailsController.movieID = searchs?[indexPath.row]?.id
        self.navigationController?.pushViewController(movieDetailsController, animated: true)
    }
}

//MARK: -  ScrollView & Loading Extension

extension SearchViewController: UIScrollViewDelegate {
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
        if position > (searchTable.contentSize.height - 100 - scrollView.frame.size.height) {
            guard !MoviesPopular.shared.ispagination else { //allready updating
                return
            }
            self.searchTable.tableFooterView = createSpinnerFooter()
            self.pageNo += 1
            if self.pageNo <= self.totalPages ?? 4 {
                paginationFetch()
            }
        }
    }
}
