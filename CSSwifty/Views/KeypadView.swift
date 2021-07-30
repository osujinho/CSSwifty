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
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            ForEach(keypadModel.keypadRows) { keypadRow in
                HStack(alignment: .top, spacing: 5){
                    ForEach(keypadRow.row) { key in
                        Button(action: {
                            switch key.value {
                            case _ where (key.value == "."):
                                if amount.contains(".") {
                                    return
                                } else if amount.isEmpty {
                                    amount.append("0.")
                                } else {
                                    amount.append(key.value)
                                }
                            case _ where (key.value == "Delete"):
                                if amount.isEmpty {
                                    return
                                } else {
                                    amount.removeLast()
                                }
                            default:
                                if amount.count < 4 {
                                    amount.append(key.value)
                                }
                            }
                        }) {
                            switch key.value {
                            case _ where (key.value == "Delete"):
                                Image(systemName: "delete.left")
                                    .keyPadButtonModifier(fontColor: .white, bgColor: .red, borderColor: .white, opacityValue: keypadModel.opacityValue(amount: amount, key: key))
                            default:
                                Text(key.value)
                                    .keyPadButtonModifier(fontColor: .white, bgColor: .blue, borderColor: .white, opacityValue: keypadModel.opacityValue(amount: amount, key: key))
                            }
                        }.disabled(amount.isEmpty && key.value == "Delete")
                        .disabled(amount.contains(".") && key.value == ".")
                    }
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
    }
}
