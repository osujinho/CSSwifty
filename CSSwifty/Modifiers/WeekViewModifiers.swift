//
//  WeekViewModifiers.swift
//  CSSwifty
//
//  Created by Michael Osuji on 7/12/21.
//

import SwiftUI

// Week Image view
struct WeekImage: View {
    let imageName: String
    let borderColor: Color
    
    var body: some View {
        VStack {
            Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .cornerRadius(10)
            .padding(5)
            .background(borderColor.cornerRadius(10))
            .padding()
        }
    }
}

// Week Summary/detail view
struct SummaryView: View {
    
    let title: String
    let bullet = "• "
    let summary: [String]
    let backgroundColor: Color
    let borderColor: Color
    
    var body: some View {
        VStack{
            Text(title)
                .font(.title)
                .padding(.bottom, 5)
            ForEach(summary, id: \.self) { topic in
                Text(bullet + topic)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .foregroundColor(.black)
        .padding(10)
        .background(backgroundColor)
        .cornerRadius(10)
        .padding(5)
        .background(borderColor.cornerRadius(10))
        .padding(.horizontal)
    }
}

// Week problem card view (What will go into the carousel)
struct ProblemCardView: View {
    var problem: Problem
    
    var body: some View {
        NavigationLink(destination: AnyView(_fromValue: problem.problemView)) {
            VStack(spacing: 0) {
                Image(problem.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
                Text(problem.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
            .background(LinearGradient(gradient: Gradient(colors: problem.gradientColors), startPoint: .topLeading, endPoint: .bottomTrailing).cornerRadius(10))
        }
    }
}

