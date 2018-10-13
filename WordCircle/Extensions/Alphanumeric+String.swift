//
//  Alphanumeric+String.swift
//  WordCircle
//
//  Created by Vamshi Krishna on 10/12/18.
//  Copyright © 2018 VamshiK. All rights reserved.
//

import Foundation

extension String {
    var containsOnlyAlphabets: Bool {
        return !isEmpty && range(of: "[^a-zA-Z]", options: .regularExpression) == nil
    }
}
