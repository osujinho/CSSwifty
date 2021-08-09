//
//  AppModel.swift
//  CSSwifty
//
//  Created by Michael Osuji on 6/30/21.
//

import SwiftUI

struct Week: Identifiable {
    let weekNumber: Int
    let title: String
    let problems: [String]
    let weekView: Any
    
    var id: Int { weekNumber }
}

struct Problem: Identifiable {
    var id: Int
    
    let title: String
    let gradientColors: [Color]
    let imageName: String
    let problemView: Any
}

