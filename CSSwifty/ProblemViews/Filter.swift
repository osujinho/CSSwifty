//
//  FilterLess.swift
//  CSSwifty
//
//  Created by Michael Osuji on 8/11/21.
//

import SwiftUI

struct Filter: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var model = FilterViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: getGradients(colors: model.problem.gradient)), startPoint: .top, endPoint: .trailing).edgesIgnoringSafeArea(.all)
            
            VStack {
                IntroView(title: "Filter", summarys: model.intro)
                
                ImageOnlyView(imageName: model.problem.image)
                
                FilterImage(imageToFilter: $model.imageToFilter, filterChoiceSelected: $model.filterChoiceSelected, filteredImage: model.filters[model.modification] ?? model.filteredImage)
                
                GridView(filterOption: $model.modification, filterChoiceSelected: $model.filterChoiceSelected)
                
            }
            .onAppear {
                model.processImage()
            }
        }.navigationBarBackButtonHidden(true)
        .subViewNavigationBar(title: model.problem.name, titleColor: .white, fontSize: 25, presentationMode: presentationMode, buttonColor: .white)
    }
}
