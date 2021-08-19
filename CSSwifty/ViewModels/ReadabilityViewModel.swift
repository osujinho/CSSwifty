//
//  ReadabilityViewModel.swift
//  CSSwifty
//
//  Created by Michael Osuji on 8/14/21.
//

import Foundation

class ReadabilityViewModel: ObservableObject {
    let intro = [
        "The Coleman-Liau index is an algorithm used to calculate the (US) grade level required to understand a text",
        "It analyzes the average number of letters and sentences per 100 words in a text",
        "This can be used to evaluate textbooks, and novels."
    ]
    
    let rules = [
        "English Language only.",
        "Space separates words.",
        "[., !, ?], ends a sentence.",
        "100 words or 500 Character limit"
    ]
    
    let week: Weeks = .week2
    let problem: Problems = .readability
    
    @Published var text = "" {
        didSet {
            if text.count > 500 {
                text = String(text.prefix(500))
            }
        }
    }
    @Published var sentenceCount = ""
    @Published var wordCount = ""
    @Published var letterCount = ""
    @Published var characterCount = ""
    @Published var grade: Grades = .none
    
    var index = 0
    
    // Function for the clear button
    func clear() {
        text = ""
        sentenceCount = ""
        wordCount = ""
        letterCount = ""
        characterCount = ""
        grade = .none
    }
    
    // Function when you press the submit button
    func submit() {
        totalLetters()
        totalWords()
        totalSentences()
        calculateIndex()
        getIndex()
    }
    
    // Function to count all the words
    func totalWords() {
        wordCount = String(text.filter { $0 == " "}.count + 1)
    }
    
    // Function to count all sentences
    func totalSentences() {
        let seperators: Set = [".", "!", "?"]
        var previousIndex = text.startIndex
        var currentIndex = text.index(after: previousIndex)
        var repeaters = ""
        
        // Counts it if the user forgets to end the final sentence with a seperator
        let lastCount = text.suffix(1).filter(\.isLetter).count
        
        // if the user inputs multiple seperators consecutively like hello!!! or final...
        while currentIndex != text.endIndex {
            if text[currentIndex] == text[previousIndex] {
                repeaters.append(text[currentIndex])
            }
            previousIndex = currentIndex
            currentIndex = text.index(after: currentIndex)
        }
        let repeatCount = repeaters.filter { seperators.contains(String($0)) }.count
        
        // Counts all the cases where the user ends the sentence with a seperator
        let allCount = text.filter { seperators.contains(String($0)) }.count
       
        sentenceCount = String(lastCount + allCount - repeatCount)
    }
    
    //Function to count all letters
    func totalLetters() {
        letterCount = String(text.filter { $0.isLetter}.count)
    }
    
    // Function to count the characters
    func totalCharacters() {
        characterCount = String(text.count)
    }
    
    // Function to calculate Coleman-Liau index
    func calculateIndex() {
        let letters = Double(letterCount) ?? 0
        let words = Double(wordCount) ?? 0
        let sentences = Double(sentenceCount) ?? 0
        
        // averageLetters - Average number of letters per 100 words in the text
        // averageSentences - Average number of sentences per 100 words in the text
        let averageLetters = ((letters / words) * 100)
        let averageSentences = ((sentences / words) * 100)
        index = Int(round((0.0588 * averageLetters) - (0.296 * averageSentences) - (15.8)))
    }
    
    // Func to get the index
    func getIndex() {
        switch index {
        case _ where index <= 0:
            grade = .zero
        case _ where index > 16:
            grade = .graduate
        default:
            Grades.allCases.forEach { calculatedGrade in
                if calculatedGrade.rawValue == index {
                    grade = calculatedGrade
                }
            }
        }
    }
}
