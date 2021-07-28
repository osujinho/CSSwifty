//
//  Week1.swift
//  CSSwifty
//
//  Created by Michael Osuji on 6/29/21.
//

import SwiftUI

struct Week1: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var appModel: AppViewModel
    @ObservedObject var model = WeekOneViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)), Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                WeekImage(imageName: "Week 1", borderColor: .black)
                    .frame(maxWidth: .infinity)
                
                SummaryView(title: model.title, summary: model.summary, backgroundColor: .white, borderColor: .black)
                    .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 5)
                
                Carousel(
                    numberOfItems: CGFloat(model.problems.count),
                    spacing: appModel.spacing,
                    widthOfHiddenCards: appModel.widthOfHiddenCards
                ){
                    ForEach(model.problems) { problem in
                        ProblemContainer(_id: problem.id, spacing: appModel.spacing, widthOfHiddenCards: appModel.widthOfHiddenCards, cardHeight: appModel.cardHeight
                        ) {
                            ProblemCardView(problem: problem)
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .subViewNavigationBar(title: "Week 1", titleColor: .white, fontSize: 30.0, presentationMode: presentationMode, buttonColor: .white)
    }
}

