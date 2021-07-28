//
//  ContentView.swift
//  CSSwifty
//
//  Created by Michael Osuji on 6/29/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appModel: AppViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [backgroundDarkGradient, backgroundLightGradient]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
                    
                
                ScrollView {
                    ForEach(appModel.weeks) { week in
                        NavigationLink (destination: AnyView(_fromValue: week.weekView),
                                        label: {
                                            WeekView(week: week)
                                        })
                    }
                }
            }
            .navigationTitle("CS Swifty")
            .navigationBarModifier(titleColor: .white, firstGradientColor: navBarDarkGradient, secondGradientColor: navBarLightGradient)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
