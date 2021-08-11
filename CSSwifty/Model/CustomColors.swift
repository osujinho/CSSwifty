//
//  CustomColors.swift
//  CSSwifty
//
//  Created by Michael Osuji on 6/30/21.
//

import SwiftUI

let backgroundDarkGradient = (Color(red: 76.5 / 255.0, green: 21.6 / 255.0, blue: 39.2 / 255.0))
let backgroundLightGradient = (Color(red: 11.4 / 255.0, green: 14.9 / 255.0, blue: 44.3 / 255.0))

let navBarDarkGradient = (Color(red: 75.3 / 255.0, green: 22.4 / 255.0, blue: 16.9 / 255.0))
let navBarLightGradient = (Color(red: 55.7 / 255.0, green: 26.7 / 255.0, blue: 67.8 / 255.0))

let containerFirstGradient = (Color(red: 29.4 / 255.0, green: 42.4 / 255.0, blue: 71.8 / 255.0))
let containerSecondGradient = (Color(red: 9.4 / 255.0, green: 15.7 / 255.0, blue: 28.2 / 255.0))

let lightPink = (Color(red: 218.0 / 255.0, green: 69.0 / 255.0, blue: 115.0 / 255.0))
let darkPink = (Color(red: 206.0 / 255.0, green: 57.0 / 255.0, blue: 77.0 / 255.0))


let pyramidColor = (Color(red: 203.0 / 255.0, green: 79.0 / 255.0, blue: 15.0 / 255.0))

func getColor(color: Colors) -> Color {
    return Color(red: color.red / 255, green: color.green / 255, blue: color.blue / 255)
}

func getGradients(colors: [Colors]) -> [Color] {
    var gradientColors = [Color]()
    for color in colors {
        gradientColors.append(getColor(color: color))
    }
    return gradientColors
}

struct Colors: Identifiable {
    let id = UUID()
    let red: Double
    let green: Double
    let blue: Double
}
