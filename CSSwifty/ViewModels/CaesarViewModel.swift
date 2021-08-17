//
//  CaesarViewModel.swift
//  CSSwifty
//
//  Created by Michael Osuji on 8/17/21.
//

import Foundation

class CaesarViewModel: ObservableObject {
    let intro = [
        "Caesar’s algorithm encrypts texts by “rotating” each letter by k positions.",
        "For any unencrypted text, the alphabets are shifted by a number of places using a secret key.",
        "Using the key, the receipient of the text will know how many places to reverse the shift of the letters to decrypt the text.",
        "The encrypted text is called cipertext, while the decrypted text is called plaintext."
    ]
    
    let rules = [
        "Enter a text to encrypt.",
        "150 Character limit",
        "Key must be 0 to 26 inclusive."
    ]
    
    let week: Weeks = .week2
    let problem: Problems = .caesar
    
    @Published var outputType: TextOption = .encrypt
    @Published var inputText = "" {
        didSet {
            if inputText.count > maximumCharacters {
                inputText = String(inputText.prefix(maximumCharacters))
            }
        }
    }
    @Published var outputText = ""
    @Published var key: UInt8 = 0
    @Published var characterCount = ""
    
    var maximumCharacters = 150
    
    // Function for the clear button
    func clear() {
        inputText = ""
        outputText = ""
        key = 0
    }
    
    // Function when you press the submit button
    func submit() {
        let texts = Array(inputText)
        var newTexts = [String]()
        let optionKey = outputType == .encrypt ? (key % 26) : (26 - (key % 26))
        let asciiValues = texts.compactMap { $0.asciiValue }
        
        for asciiValue in asciiValues {
            
            if (65...90).contains(asciiValue) {
                let cipherAscii = 65 + (((asciiValue - 65) + (optionKey % 26)) % 26)
                let cipherChar = String(UnicodeScalar(cipherAscii))
                
                newTexts.append(cipherChar)
            } else if (97...122).contains(asciiValue) {
                let cipherAscii = 97 + (((asciiValue - 97) + (optionKey % 26)) % 26)
                let cipherChar = String(UnicodeScalar(cipherAscii))
                
                newTexts.append(cipherChar)
            } else {
                let ciperChar = String(UnicodeScalar(asciiValue))
                newTexts.append(ciperChar)
            }
        }
        outputText = newTexts.joined()
    }
    
    func totalCharacter() {
        characterCount = String(inputText.count)
    }
    
    func textEditorLabel() -> String {
        outputType == .encrypt ? "Enter plaintext" : "Enter ciphertext"
    }
    
}


enum TextOption: String, CaseIterable, Identifiable {
    case encrypt, decrypt
    
    var id: TextOption { self }
    
    var name: String {
        return self.rawValue.capitalized
    }
}
