//
//  WeekOneViewModel.swift
//  CSSwifty
//
//  Created by Michael Osuji on 7/12/21.
//

import Foundation

class WeekOneViewModel: ObservableObject {
    let title = "Week 1 Overview"
    
    let summary = [
        "Data Types",
        "Operators",
        "Conditional Statements",
        "Loops"
    ]
    
    let problems = [
        Problem(id: 0, title: "Mario Less", gradientColors: [marioLessFirstColor, marioLessSecondColor], imageName: "Mario-Less", problemView: MarioLess()),
        Problem(id: 1, title: "Mario More", gradientColors: [marioMoreFirstColor, marioMoreSecondColor], imageName: "Mario-More", problemView: MarioMore()),
        Problem(id: 2, title: "Cash", gradientColors: [cashFirstColor, cashSecondColor, cashThirdColor], imageName: "Cash", problemView: Cash()),
        Problem(id: 3, title: "Credit", gradientColors: [creditFirstColor, creditSecondColor], imageName: "Credit", problemView: Credit())
    ]
}
