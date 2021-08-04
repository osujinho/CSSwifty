//
//  KeypadViewModel.swift
//  CSSwifty
//
//  Created by Michael Osuji on 7/30/21.
//

import SwiftUI

struct Key: Identifiable {
    var id: Int
    var value: String
}

struct KeypadRow: Identifiable {
    var id: Int
    var row: [Key]
}

class KeypadViewModel {
    
    var keypadRows = [
        KeypadRow(id: 0, row: [Key(id: 0, value: "1"), Key(id: 1, value: "2"), Key(id: 2, value: "3"), Key(id: 3, value: "4")]),
        KeypadRow(id: 1, row: [Key(id: 0, value: "5"), Key(id: 1, value: "6"), Key(id: 2, value: "7"), Key(id: 3, value: "8")]),
        KeypadRow(id: 2, row: [Key(id: 0, value: "Any"), Key(id: 1, value: "9"), Key(id: 2, value: "0"), Key(id: 3, value: "Delete")])
    ]
    
    func opacityValue(amount: String, key: Key, hasDecimal: Bool) -> Double {
        var opacityDouble = 0.0
        
        switch amount {
        case _ where (hasDecimal && amount.contains(".") && key.value == "Any"):
            opacityDouble = 0.6
        case _ where (!hasDecimal && amount.count < 13 && key.value == "Any"):
            opacityDouble = 0.6
        case _ where (amount.isEmpty && key.value == "Delete"):
            opacityDouble = 0.6
        default:
            opacityDouble = 1.0
        }
        return opacityDouble
    }
    
    func borderColor(key: Key, bgColor: Color) -> Color {
        var lineColor: Color
        
        key.value == "Delete" ? (lineColor = Color.red) : (lineColor = bgColor)
        
        return lineColor
    }
    
    func keypadAction(key: Key, hasDecimal: Bool, maxDigits: Int, amount: inout String, submitFunction: () -> Void = { }) {
        
        switch key.value {
        case _ where (key.value == "Any"):
            if hasDecimal {
                switch amount {
                case _ where (amount.contains(".")):
                    return
                case _ where (amount.isEmpty):
                    amount.append("0.")
                default:
                    amount.append(".")
                }
            } else {
                switch amount {
                case _ where (amount.isEmpty):
                    return
                default:
                    submitFunction()
                }
            }
        case _ where (key.value == "Delete"):
            if amount.isEmpty {
                return
            } else {
                amount.removeLast()
            }
        default:
            if amount.count < maxDigits {
                amount.append(key.value)
            }
        }
    }
    
    func keypadLabel(key: Key, hasDecimal: Bool, amount: String) -> AnyView {
        var label: AnyView
        
        switch key.value {
        case _ where (key.value == "Any"):
            if hasDecimal {
                label = AnyView(Text(".").keyPadButtonModifier(fontColor: .white, bgColor: .blue, borderColor: .white, opacityValue: opacityValue(amount: amount, key: key, hasDecimal: hasDecimal)))
            } else {
                label = AnyView(Image(systemName: "return").keyPadButtonModifier(fontColor: .white, bgColor: .green, borderColor: .white, opacityValue: opacityValue(amount: amount, key: key, hasDecimal: hasDecimal)))
                
            }
        case _ where (key.value == "Delete"):
            label = AnyView(Image(systemName: "delete.left").keyPadButtonModifier(fontColor: .white, bgColor: .red, borderColor: .white, opacityValue: opacityValue(amount: amount, key: key, hasDecimal: hasDecimal)))
        default:
            label = AnyView(Text(key.value).keyPadButtonModifier(fontColor: .white, bgColor: .blue, borderColor: .white, opacityValue: opacityValue(amount: amount, key: key, hasDecimal: hasDecimal)))
        }
        return label
    }
}
