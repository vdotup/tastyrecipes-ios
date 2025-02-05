//
//  StarIconHelper.swift
//  TastyRecipes
//
//  Created by Abdurrahman Alfudeghi on 05/02/2025.
//

import SwiftUI

struct StarIconHelper {
    static func starIcon(_ rating: Double, index: Double) -> String {
        if rating >= index { return "star.fill" }
        else if rating + 0.5 >= index { return "star.leadinghalf.filled" }
        else { return "star" }
    }
}
