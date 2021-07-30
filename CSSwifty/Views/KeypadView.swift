//
//  KeypadView.swift
//  CSSwifty
//
//  Created by Michael Osuji on 7/30/21.
//

import SwiftUI

struct KeypadView: View {
    
    var keypadModel = KeypadViewModel()
    @Binding var amount: String
    
    let hasdecimal: Bool
    let maxDigits: Int
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            ForEach(keypadModel.keypadRows) { keypadRow in
                HStack(alignment: .top, spacing: 5){
                    ForEach(keypadRow.row) { key in
                        Button(action: {
                            keypadModel.keypadAction(key: key, hasDecimal: hasdecimal, maxDigits: maxDigits, amount: &amount)
                        }) {
                            keypadModel.keypadLabel(key: key, hasDecimal: hasdecimal, amount: amount)
                        }.disabled(amount.isEmpty && key.value == "Delete")
                        .disabled(amount.contains(".") && key.value == "Any" && hasdecimal)
                        .disabled(amount.isEmpty && key.value == "Any" && !hasdecimal)
                    }
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
    }
}
