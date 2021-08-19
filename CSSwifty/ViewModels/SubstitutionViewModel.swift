//
//  SubstitutionViewModel.swift
//  CSSwifty
//
//  Created by Michael Osuji on 8/19/21.
//

import Foundation

class SubstitutionViewModel: ObservableObject {
    @Published var outputType: TextOption = .encrypt
    @Published var inputText = "" {
        didSet {
            // Maximum 150 characters
            if inputText.count > maximumCharacters {
                inputText = String(inputText.prefix(maximumCharacters))
            }
        }
    }
    @Published var outputText = ""
    @Published var key = ""
    @Published var characterCount = ""
    
    let intro = [
        "In substitution cipher, a plain text is encrypted by swapping each letter by a different letter in the key.",
        "For a key like NQXPOMAFTRHLZGECYJIUWSKDVB, A (the first letter of the alphabet) will be converted to N (the first letter of the key); B would become Q and so forth."
    ]
    let rules = [
        "150 Character limit",
        "Key must be all 26 alphabets in any order",
        "No duplicate alphabets in the key"
    ]
    let week: Weeks = .week2
    let problem: Problems = .substitution
    var maximumCharacters = 150
    
    // Function for the clear button
    func clear() {
        inputText = ""
        outputText = ""
        key = ""
    }
    
    // Duplicate letters
    func validateKey() {
        var setOfKeys = Set<String>()
        
        for letter in key {
            switch letter {
            case _ where (setOfKeys.contains(letter.lowercased())):
                key.removeLast()
            case _ where (setOfKeys.contains(letter.uppercased())):
                key.removeLast()
            case _ where (setOfKeys.count > 26):
                key = String(key.prefix(26))
            case _ where (!letter.isLetter):
                key.removeLast()
            default:
                setOfKeys.insert(String(letter))
            }
        }
    }
    
    // Function to cipher or decipher each letter
    private func cipherFor(dictionary: [UInt8 : UInt8], asciiValue: UInt8) -> String {
        switch asciiValue {
        case _ where (65...90).contains(asciiValue):
            return dictionary.filter { $0.key == (asciiValue + 32) }.values.compactMap { String(UnicodeScalar($0 - 32)) }.joined()
        case _ where (97...122).contains(asciiValue):
            return dictionary.filter { $0.key == asciiValue }.values.compactMap { String(UnicodeScalar($0)) }.joined()
        default:
            return String(UnicodeScalar(asciiValue))
        }
    }

    // function to modify the text based on type
    func modifiedText() {
        let keyAscii = key.map { $0.lowercased() }.joined().compactMap { $0.asciiValue }
        let alphabetsAscii = "abcdefghijklmnopqrstuvwxyz".compactMap { $0.asciiValue }
        
        // Made it so the key is swapped when the user decided to decrypt instead of encrypt
        let keyDictionary = Dictionary(uniqueKeysWithValues: outputType == .encrypt ?  zip(alphabetsAscii, keyAscii) : zip(keyAscii, alphabetsAscii))
        
        let newtexts = inputText.compactMap { $0.asciiValue }.map { cipherFor(dictionary: keyDictionary, asciiValue: $0) }
        outputText = newtexts.joined()
    }
    
    func totalCharacter() {
        characterCount = String(inputText.count)
    }
    
    func textEditorLabel() -> String {
        outputType == .encrypt ? "Enter plaintext" : "Enter ciphertext"
    }
}
