//
//  WeekList.swift
//  CSSwifty
//
//  Created by Michael Osuji on 6/30/21.
//

import SwiftUI

// View Composition for the Circle week number
struct WeekCircle: View {
    let week: Weeks
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(gradient: Gradient(colors: [lightPink, darkPink]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                )
            VStack{
                Text("Week")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                Text("\(week.number)")
                    .font(.caption)
                    .foregroundColor(.white)
            }
        }.frame(width: 70, height: 70, alignment: .center)
    }
}

// View Composition for the Problem set names
struct ProblemSet: View {
    var problem: Problems
    var fontSize: CGFloat = 12.0
    
    var body: some View {
        ZStack {
            Text(problem.name)
                .font(.system(size: fontSize, weight: .regular))
                .lineLimit(2)
                .foregroundColor(.white)
                .padding(5)
                .background(Color.green)
                .cornerRadius(5.0)
        }
    }
}


// View composition for the week view list
struct WeekDetail: View {
    let week: Weeks
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(week.topic)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .lineLimit(2)
                .padding(.bottom, 5)
            Text("Problem Sets")
                .foregroundColor(.gray)
                .padding(.bottom, 2)
            HStack {
                ForEach(week.problems, id: \.self) { problem in
                    ProblemSet(problem: problem)
                }
            }
        }.padding(.trailing, 10)
        .padding(.leading, 10)
    }
}


// View Composition for the Week View
struct WeekContainer: View {
    let week: Weeks
    
    var body: some View {
        NavigationLink(destination: WeekView(week: week)) {
            HStack(alignment: .center) {
                WeekCircle(week: week)
                    .padding(.leading, 5)
                WeekDetail(week: week)
                    .padding(.bottom, 5)
                Spacer()
            }.containerModifier()
        }
    }
}


// HStack for the week container modifier
struct ContainerModifier: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .padding(.top, 10)
            .padding(.bottom, 10)
            .background(LinearGradient(gradient: Gradient(colors: [containerFirstGradient, containerSecondGradient]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
            .padding(.all, 10)
    }
}

extension View {
    func containerModifier() -> some View {
        self.modifier(ContainerModifier())
    }
}


