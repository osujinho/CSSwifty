//
//  MarioLessViewModel.swift
//  CSSwifty
//
//  Created by Michael Osuji on 7/20/21.
//

import Foundation

class MarioLessViewModel: ObservableObject {
    let intro = [
        "Toward the end of World 1-1 in Nintendo’s Super Mario Brothers, Mario must ascend right-aligned pyramid of blocks",
        "Let us recreate the pyramids using blocks in SwiftUI"
    ]
    
    let rules = [
        "ONLY positive integers",
        "Numbers from 1-8 inclusive"
    ]
    
    @Published var selectedHeight = 0
    
    func drawPyramid() -> String {
        let block = "◼︎"
        let space = " "
        
        var pyramid = ""
        
        for character in 0..<self.selectedHeight {
            let totalSpace = String(repeating: space, count: ((self.selectedHeight - 1) - character))
            let totalBlocks = String(repeating: block, count: (character + 1))
            
            let combinedCharacter = totalSpace + totalBlocks + "\n"
            pyramid.append(combinedCharacter)
        }
        return pyramid
    }
}
