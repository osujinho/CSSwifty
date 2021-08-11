//
//  WeekViewModifiers.swift
//  CSSwifty
//
//  Created by Michael Osuji on 7/12/21.
//

import SwiftUI

// Week Image view
struct WeekImage: View {
    let week: Weeks
    let borderColor: Color
    
    var body: some View {
        VStack {
            Image(week.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(10)
            .padding(5)
            .background(borderColor.cornerRadius(10))
            .padding()
        }.frame(maxWidth: .infinity)
    }
}

// Week Summary/detail view
struct SummaryView: View {
    
    let week: Weeks
    let bullet = "• "
    
    let columns = [
        GridItem(.adaptive(minimum: 160))
    ]
    
    var body: some View {
        
        LazyVGrid(columns: columns, alignment: .leading, spacing: 10, pinnedViews: [.sectionHeaders]) {
            Section(header: Text(week.name + " Overview").font(.title3).fontWeight(.bold).foregroundColor(.white)) {
                ForEach(week.overview, id: \.self) { topic in
                    HStack(alignment: .firstTextBaseline) {
                        Text(bullet)
                        Text(topic)
                    }
                }
            }
        }
        .foregroundColor(.white)
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
    }
}


// Week problem card view (What will go into the carousel)
struct ProblemCardView: View {
    
    var problems: [Problems]
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        
        LazyVGrid(columns: columns, alignment: .center, spacing: 20, pinnedViews: [.sectionHeaders]) {
            Section(header: Text("Problem Sets").font(.title3).fontWeight(.bold).foregroundColor(.white)) {
                ForEach(problems, id: \.rawValue) { problem in
                    NavigationLink(destination: AnyView(_fromValue: problem.view)) {
                        ZStack(alignment: .center) {
                            LinearGradient(gradient: Gradient(colors: getGradients(colors: problem.gradient)), startPoint: .topLeading, endPoint: .bottomTrailing)
                            HStack {
                                Image(systemName: problem.icon)
                                Text(problem.name)
                                    .font(.headline)
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                        }
                        .frame(height: 70)
                        .cornerRadius(30)
                        .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.white, lineWidth: 2))
                        .shadow(color: .black, radius: 2)
                    }
                }
            }
            
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        
    }
}

