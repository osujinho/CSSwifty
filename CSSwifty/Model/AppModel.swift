//
//  AppModel.swift
//  CSSwifty
//
//  Created by Michael Osuji on 6/30/21.
//

import SwiftUI

enum Weeks: String, CaseIterable {
    case week1, week2, week3, week4, week5, week6, week7, week8
    
    var name: String {
        let space: Character = " "
        return String(self.rawValue.enumerated().flatMap { $0 > 0 && $0 % 4 == 0 ? [space, $1] : [$1] } ).capitalized
    }
    
    var image: String {
        return self.rawValue
    }
    
    var number: Int {
        return Int(self.rawValue.filter{ ("0"..."9").contains($0) }) ?? 0
    }
    
    var topic: String {
        switch self {
        case .week1: return "C-Programming"
        case .week2: return "Arrays"
        case .week3: return "Algorithms"
        case .week4: return "Memory"
        case .week5: return "Data Structures"
        case .week6: return "Python"
        case .week7: return "SQL"
        case .week8: return "Information"
        }
    }
    
    
    var gradient: [Colors] {
        switch self {
        case .week1:
            return [Colors(red: 242, green: 166, blue: 90), Colors(red: 119, green: 47, blue: 26)]
        case .week2:
            return [Colors(red: 197, green: 142, blue: 127), Colors(red: 223, green: 163, blue: 117)]
        case .week3:
            return [Colors(red: 93, green: 73, blue: 84), Colors(red: 255, green: 166, blue: 158)]
        case .week4:
            return [Colors(red: 203, green: 163, blue: 109), Colors(red: 226, green: 172, blue: 107)]
        case .week5:
            return [Colors(red: 226, green: 172, blue: 107), Colors(red: 224, green: 210, blue: 180)]
        case .week6:
            return [Colors(red: 232, green: 188, blue: 133), Colors(red: 232, green: 201, blue: 155)]
        case .week7:
            return [Colors(red: 231, green: 169, blue: 119), Colors(red: 235, green: 190, blue: 155)]
        case .week8:
            return [Colors(red: 204, green: 153, blue: 52), Colors(red: 30, green: 29, blue: 27)]
        }
    }
    
    var overview: [String] {
        switch self {
        case .week1:
            return ["Data Types", "Operators", "Conditional Statements", "Loops"]
        case .week2:
            return ["Functions", "Variables and scope", "Arrays"]
        case .week3:
            return ["Linear Search", "Binary Search", "Bubble Sort", "Selection Sort", "Recursion", "Merge Sort"]
        case .week4:
            return ["Hexadecimal", "Pointers", "Defining Custom Types", "Dynamic Memory Allocation", "Call Stacks", "File Pointers"]
        case .week5:
            return ["Data Structures", "Singly-Linked Lists", "Hash Tables", "Tries"]
        case .week6:
            return ["Python Basics", "Input, Conditions", "Overflow, Imprecision", "Lists, Strings", "Algorithms"]
        case .week7:
            return ["SQL Basics", "Cleaning", "Searching", "Counting", "Tables"]
        case .week8:
            return ["Web Development", "Mobile Development", "Game Development", "Final Project"]
        }
    }
    
    var problems: [Problems] {
        switch self {
        case .week1: return [.marioless, .mariomore, .cash, .credit]
        case .week2: return [.readability, .caesar, .substitution]
        case .week3: return [.plurality, .runoff, .tideman]
        case .week4: return [.filterless, .filtermore, .recover]
        case .week5: return [.speller]
        case .week6: return [.dna]
        case .week7: return [.movies, .fiftyville]
        case .week8: return [.none]
        }
    }
}

struct Problemz: Identifiable {
    var id = UUID()
    
    let name: String
    let gradient: [Colors]
    let icon: String
    let view: Any
}

enum Problems: String, CaseIterable {
    case marioless, mariomore, cash, credit, readability, caesar, substitution, plurality, runoff, tideman, filterless, filtermore, recover, speller, dna, movies, fiftyville, none

    var name: String {
        switch self {
        case .marioless: return "Mario Less"
        case .mariomore: return "Mario More"
        case .cash: return "Cash"
        case .credit: return "Credit"
        case .readability: return "Readability"
        case .caesar: return "Caesar"
        case .substitution: return "Substitution"
        case .plurality: return "Plurality"
        case .runoff: return "Runoff"
        case .tideman: return "Tideman"
        case .filterless: return "Filter Less"
        case .filtermore: return "Filter More"
        case .recover: return "Recover"
        case .speller: return "Speller"
        case .dna: return "DNA"
        case .movies: return "Movies"
        case .fiftyville: return "Fiftyville"
        case .none: return "None"
        }
    }
    
    var icon: String {
        switch self {
        case .marioless: return "play.fill"
        case .mariomore: return "pyramid.fill"
        case .cash: return "banknote.fill"
        case .credit: return "creditcard.fill"
        case .readability: return "book.fill"
        case .caesar: return "eye.slash.fill"
        case .substitution: return "arrowshape.bounce.forward.fill"
        case .plurality: return "person.fill.checkmark"
        case .runoff: return "person.3.fill"
        case .tideman: return "person.fill.questionmark"
        case .filterless: return "circles.hexagongrid.fill"
        case .filtermore: return "circles.hexagonpath.fill"
        case .recover: return "puzzlepiece.fill"
        case .speller: return "pencil.circle.fill"
        case .dna: return "touchid"
        case .movies: return "film.fill"
        case .fiftyville: return "folder.fill.badge.questionmark"
        case .none: return "poweroff"
        }
    }
    
    var image: String {
        return self.rawValue
    }
    
    var gradient: [Colors] {
        switch self {
        case .marioless: return [Colors(red: 167, green: 29, blue: 49), Colors(red: 63, green: 13, blue: 18)]
        case .mariomore: return [Colors(red: 185, green: 19, blue: 114), Colors(red: 107, green: 15, blue: 26)]
        case .cash: return [Colors(red: 164, green: 6, blue: 6), Colors(red: 217, green: 131, blue: 36)]
        case .credit: return [Colors(red: 76, green: 19, blue: 26), Colors(red: 178, green: 80, blue: 92)]
        case .readability: return [Colors(red: 55, green: 213, blue: 214), Colors(red: 54, green: 9, blue: 109)]
        case .caesar: return [Colors(red: 8, green: 200, blue: 246), Colors(red: 77, green: 93, blue: 251)]
        case .substitution: return [Colors(red: 109, green: 23, blue: 203), Colors(red: 40, green: 118, blue: 249)]
        case .plurality: return [Colors(red: 35, green: 51, blue: 41), Colors(red: 99, green: 212, blue: 113)]
        case .runoff: return [Colors(red: 0, green: 0, blue: 0), Colors(red: 22, green: 109, blue: 59)]
        case .tideman: return [Colors(red: 0, green: 0, blue: 0), Colors(red: 85, green: 239, blue: 196)]
        case .filterless: return [Colors(red: 248, green: 222, blue: 126), Colors(red: 217, green: 144, blue: 88)]
        case .filtermore: return [Colors(red: 249, green: 217, blue: 118), Colors(red: 243, green: 159, blue: 134)]
        case .recover: return [Colors(red: 255, green: 222, blue: 168), Colors(red: 254, green: 200, blue: 78)]
        case .speller: return [Colors(red: 95, green: 10, blue: 135), Colors(red: 164, green: 80, blue: 139)]
        case .dna: return [Colors(red: 210, green: 204, blue: 196), Colors(red: 47, green: 67, blue: 83)]
        case .movies: return [Colors(red: 13, green: 50, blue: 77), Colors(red: 127, green: 90, blue: 131)]
        case .fiftyville: return [Colors(red: 167, green: 172, blue: 217), Colors(red: 158, green: 143, blue: 178)]
        case .none: return [Colors(red: 150, green: 112, blue: 91), Colors(red: 186, green: 154, blue: 142)]
        }
    }
    
    var view: Any {
        switch self {
        case .marioless: return MarioLess()
        case .mariomore: return MarioMore()
        case .cash: return Cash()
        case .credit: return Credit()
        case .readability: return Readability()
        case .caesar: return Caesar()
        case .substitution: return Substitution()
        case .plurality: return Plurality()
        case .runoff: return Runoff()
        case .tideman: return Tideman()
        case .filterless: return FilterLess()
        case .filtermore: return FilterMore()
        case .recover: return Recover()
        case .speller: return Speller()
        case .dna: return Dna()
        case .movies: return Movies()
        case .fiftyville: return Fiftyville()
        case .none: return EmptyView()
        }
    }
}

typealias Func = () -> Void

enum ValidStatus: String, Identifiable {
    case none
    case valid
    case invalid
    
    var status: String {
        return self.rawValue.uppercased()
    }
    
    var id: ValidStatus { self }
}
