//
//  MarioMoreViewModel.swift
//  CSSwifty
//
//  Created by Michael Osuji on 7/21/21.
//

import Foundation

class MarioMoreViewModel: ObservableObject {
    let intro = [
        "Toward the beginning of World 1-1 in Nintendo’s Super Mario Brothers, Mario must hop over adjacent pyramids of blocks",
        "Let us recreate the adjacent pyramids using blocks in SwiftUI"
    ]
    
    let rules = [
        "ONLY positive integers",
        "Numbers from 1-8 inclusive"
    ]
    
    @Published var selectedHeight = 0
    
    func drawPyramid() -> String {
        let block = "◼︎"
        let space = " "
        let separator = "  "
        
        var pyramid = ""
        
        for character in 0..<self.selectedHeight {
            let totalSpace = String(repeating: space, count: ((self.selectedHeight - 1) - character))
            let totalBlocks = String(repeating: block, count: (character + 1))
            
            let combinedCharacter = totalSpace + totalBlocks + separator + totalBlocks + totalSpace + "\n"
            pyramid.append(combinedCharacter)
        }
        return pyramid
    }
}
