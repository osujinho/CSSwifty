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
    @Published var key: Int = 0
    @Published var characterCount = ""
    
    var maximumCharacters = 150
    
    // Function for the clear button
    func clear() {
        inputText = ""
        outputText = ""
        key = 0
    }
    
    // Function to determine the ascii values based on case
    
    private func cypherFor(asciiValue: UInt8, key: UInt8) -> String {
        switch asciiValue {
        case _ where (65...90).contains(asciiValue):
            return String(UnicodeScalar(65 + (((asciiValue - 65) + (key % 26)) % 26)))
        case _ where (97...122).contains(asciiValue):
            return String(UnicodeScalar(97 + (((asciiValue - 97) + (key % 26)) % 26)))
        default:
            return String(UnicodeScalar(asciiValue))
        }
    }

    // Function to return cipher text.
    func newCipherText() {
        let optionKey = outputType == .encrypt ? UInt8(key % 26) : UInt8(26 - (key % 26))
        let newTexts = inputText.compactMap { $0.asciiValue }.map { cypherFor(asciiValue: $0, key: optionKey)}
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
