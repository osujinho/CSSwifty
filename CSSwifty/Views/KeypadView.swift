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
    
    let hasDecimal: Bool
    let maxDigits: Int
    let submitFunction: Func
    
    init(
        amount: Binding<String>,
        hasDecimal: Bool,
        maxDigits: Int,
        submitFunction: @escaping Func = { }) {
        self._amount = amount
        self.hasDecimal = hasDecimal
        self.maxDigits = maxDigits
        self.submitFunction = submitFunction
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            ForEach(keypadModel.keypadRows) { keypadRow in
                HStack(alignment: .top, spacing: 5){
                    ForEach(keypadRow.row) { key in
                        Button(action: {
                            keypadModel.keypadAction(
                                key: key,
                                hasDecimal: hasDecimal,
                                maxDigits: maxDigits,
                                amount: &amount,
                                submitFunction: submitFunction)
                        }) {
                            keypadModel.keypadLabel(key: key, hasDecimal: hasDecimal, amount: amount)
                        }.disabled(amount.isEmpty && key.value == "Delete")
                        .disabled(amount.contains(".") && key.value == "Any" && hasDecimal)
                        .disabled(amount.count < 13 && key.value == "Any" && !hasDecimal)
                    }
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
    }
}
