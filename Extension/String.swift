//
//  String.swift
//  WarmGreeting
//
//  Created by apple on 16.11.2021.
//

import UIKit
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
