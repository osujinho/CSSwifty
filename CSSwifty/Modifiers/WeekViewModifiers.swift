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
    
    var body: some View {
        VStack{
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 1)
            ForEach(summary, id: \.self) { topic in
                Text(bullet + topic)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .foregroundColor(.white)
        .padding(10)
        .padding(.horizontal, 15)
    }
}

// Week problem card view (What will go into the carousel)
struct ProblemCardView: View {
    var problem: Problem
    
    var body: some View {
        NavigationLink(destination: AnyView(_fromValue: problem.problemView)) {
            ZStack(alignment: .bottom) {
                Image(problem.imageName)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Capsule())
                HStack {
                    Spacer()
                    Text(problem.title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Spacer()
                }
                .background(Color.gray.opacity(0.7))
            }
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 2))
            .shadow(color: .black, radius: 2)
            
        }
    }
}

