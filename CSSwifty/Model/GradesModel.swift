//
//  GradesModel.swift
//  CSSwifty
//
//  Created by Michael Osuji on 8/14/21.
//

import Foundation

enum Grades: Int, CaseIterable {
    case none = -20, zero = 0, one, two, three, four, five, six, seven, eight, nine, ten, eleven, twelve, thirteen, fourteen, fifteen, sixteen, graduate
    
    var name: String {
        switch self {
        
        case .none: return ""
        case .zero: return "Pre-School and Kindergarten"
        case .one: return "Grade 1 - Elementary"
        case .two: return "Grade 2 - Elementary"
        case .three: return "Grade 3 - Elementary"
        case .four: return "Grade 4 - Elementary"
        case .five: return "Grade 5 - Elementary"
        case .six: return "Grade 6 - Middle School"
        case .seven: return "Grade 7 - Middle School"
        case .eight: return "Grade 8 - Middle School"
        case .nine: return "Grade 9 - High School Freshman"
        case .ten: return "Grade 10 - High School Sophomore"
        case .eleven: return "Grade 11 - High School Junior"
        case .twelve: return "Grade 12 - High School Senior"
        case .thirteen: return "Grade 13 - College Freshman"
        case .fourteen: return "Grade 14 - College Sophomore"
        case .fifteen: return "Grade 15 - College Junior"
        case .sixteen: return "Grade 16 - College Senior"
        case .graduate: return "Grade 17+ - Graduate Student"
        }
    }
}
