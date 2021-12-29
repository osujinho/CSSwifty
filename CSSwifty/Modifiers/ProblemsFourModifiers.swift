//
//  ProblemsFourModifiers.swift
//  CSSwifty
//
//  Created by Michael Osuji on 12/28/21.
//

import SwiftUI

// To display only the image
struct ImageOnlyView: View {
    let imageName: String
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
        }
        .containerViewModifier(fontColor: .white, borderColor: .black)
    }
}

// Grid View for filter options
struct GridView: View {
    let filters = Modification.allCases
    @Binding var filterOption: Modification
    @Binding var filterChoiceSelected: Bool
    
    let columns = [GridItem(.adaptive(minimum: 75, maximum: 80))]
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .center, spacing: 8, pinnedViews: [.sectionHeaders]) {
            Section(header: Text("Filter Options").font(.title3).fontWeight(.bold).foregroundColor(.white)) {
                ForEach(filters, id: \.rawValue) { filter in
                    Button(filter.label,
                           action: {
                        filterOption = filter.self
                        filterChoiceSelected = true
                    })
                        .foregroundColor(.white)
                        .font(.caption)
                        .padding(8)
                        .padding(.horizontal, 3)
                        .background(filter.color)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}
