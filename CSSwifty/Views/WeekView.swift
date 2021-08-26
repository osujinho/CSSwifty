//
//  WeekView.swift
//  CSSwifty
//
//  Created by Michael Osuji on 8/11/21.
//

import SwiftUI

struct WeekView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let week: Weeks
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: getGradients(colors: week.gradient)), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
        
            VStack(spacing: 10) {
                Text(week.topic)
                    .font(.system(size: 18))
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                
                WeekImage(week: week, borderColor: .black)
                
                SummaryView(week: week)
                
                ProblemCardView(problems: week.problems)
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .subViewNavigationBar(title: week.name, titleColor: .white, fontSize: 25, presentationMode: presentationMode, buttonColor: .white)
    }
}
