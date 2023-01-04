//
//  TabbarViewController.swift
//  Movies
//
//  Created by aytü on 10.08.2022.
//

import UIKit

class TabbarViewController: UITabBarController {

    @IBOutlet weak var tabbar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitles()
    }
    
    private func setTitles() {
        guard let items = tabbar.items else {
            return
        }
        items[0].title = "movies".localize()
        items[1].title = "favorites".localize()
        items[2].title = "search".localize()
    }
}
