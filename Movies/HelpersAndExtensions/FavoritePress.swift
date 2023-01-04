//
//  FavoritePress.swift
//  Movies
//
//  Created by aytü on 10.08.2022.
//

import Foundation
import UIKit

class FavoritePress {
    static let shared = FavoritePress()
    
    func press(sender: UIButton ) {
        guard let hiddenID = sender.titleLabel?.text else {
            return
        }
        if sender.currentImage == UIImage(systemName: "star.slash") {
            sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
            UDM.shared.defaults.set(true, forKey: hiddenID)
            UDM.shared.appendKey(id: hiddenID)
        } else {
            sender.setImage( UIImage(systemName: "star.slash"), for: .normal)
            UDM.shared.defaults.removeObject(forKey: hiddenID)
            UDM.shared.removeKey(id: hiddenID)
        }
        UDM.shared.saveKeys()
    }
}
