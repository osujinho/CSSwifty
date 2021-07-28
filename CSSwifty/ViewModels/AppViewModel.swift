//
//  AppViewModel.swift
//  CSSwifty
//
//  Created by Michael Osuji on 6/30/21.
//

import SwiftUI

class AppViewModel: ObservableObject{
    @Published var activeCard: Int = 0
    @Published var screenDrag: Float = 0.0
    
    @Published var weeks = [
        Week(weekNumber: 1, title: "C-Programming", problems: ["Mario Less", "Mario More", "Cash", "Credit"], weekView: Week1()),
        Week(weekNumber: 2, title: "Arrays", problems: ["Readability", "Caesar", "Substitution"], weekView: Week2()),
        Week(weekNumber: 3, title: "Algorithms", problems: ["Plurality", "Runoff", "Tideman"], weekView: Week3()),
        Week(weekNumber: 4, title: "Memory", problems: ["Filter Less", "Filter More", "Recover"], weekView: Week4()),
        Week(weekNumber: 5, title: "Data Structures", problems: ["Speller"], weekView: Week5()),
        Week(weekNumber: 6, title: "Python", problems: ["DNA"], weekView: Week6()),
        Week(weekNumber: 7, title: "SQL", problems: ["Movies", "Houses"], weekView: Week7()),
        Week(weekNumber: 8, title: "Information", problems: ["None"], weekView: Week8())
    ]
    
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    let spacing: CGFloat = 16
    let widthOfHiddenCards: CGFloat = 32
    let cardHeight: CGFloat = UIScreen.main.bounds.height / 3.5
    
    func onReceive(numberOfCards: Int) {
        activeCard = (activeCard + 1) % numberOfCards
    }
    
    func onEnded( value: GestureStateGesture<DragGesture, Bool>.Value) {
        self.screenDrag = 0
        
        if (value.translation.width < -50) {
            self.activeCard = self.activeCard + 1
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
        }
        
        if (value.translation.width > 50) {
            self.activeCard = self.activeCard - 1
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
        }
    }
}
