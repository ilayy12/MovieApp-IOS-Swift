//
//  LocalizeExtension.swift
//  Movies
//
//  Created by aytü on 2.08.2022.
//

import Foundation

extension String {
    func localize() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: .main, value: "", comment: self)
    }
}

class Lang {
    static let shared = Lang()
    let langCode = Locale.current.languageCode
}
