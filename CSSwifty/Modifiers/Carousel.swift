//
//  Carousel.swift
//  CSSwifty
//
//  Created by Michael Osuji on 7/20/21.
//

import SwiftUI

struct Carousel<Content: View>: View {
    let content: Content
    let numberOfItems: CGFloat
    let spacing: CGFloat
    let widthOfHiddenCards: CGFloat
    let totalSpacing: CGFloat
    let cardWidth: CGFloat
    
    @GestureState var isDetectingLongPress = false
    @EnvironmentObject var appModel: AppViewModel
    
    @inlinable public init(
        numberOfItems: CGFloat,
        spacing: CGFloat,
        widthOfHiddenCards: CGFloat,
        @ViewBuilder _ content: () -> Content) {
        
        self.content = content()
        self.numberOfItems = numberOfItems
        self.spacing = spacing
        self.widthOfHiddenCards = widthOfHiddenCards
        self.totalSpacing = (numberOfItems - 1) * spacing
        self.cardWidth = UIScreen.main.bounds.width - (widthOfHiddenCards * 2) - (spacing * 2)
    }
    
    var body: some View {
        let totalCanvasWidth: CGFloat = (cardWidth * numberOfItems) + totalSpacing
        let xOffsetToShift = (totalCanvasWidth - UIScreen.main.bounds.width) / 2
        let leftPadding = widthOfHiddenCards + spacing
        let totalMovement = cardWidth + spacing
        let cardOffset = totalMovement * CGFloat(appModel.activeCard)
        
        
        let activeOffset = xOffsetToShift + leftPadding - cardOffset
        let nextOffset = xOffsetToShift + leftPadding - (cardOffset + 1)
        
        var calcOffset = Float(activeOffset)
        
        if (calcOffset != Float(nextOffset)) {
            calcOffset = Float(activeOffset) + appModel.screenDrag
        }
        
        return HStack(alignment: .center, spacing: spacing) {
            content
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(Color.clear.edgesIgnoringSafeArea(.all))
        .offset(x: CGFloat(calcOffset), y: 0)
        .onReceive( appModel.timer ) { _ in
            appModel.onReceive(numberOfCards: Int(numberOfItems))
        }
        .gesture(DragGesture().updating($isDetectingLongPress) { currentState, gestureState, transaction in
            self.appModel.screenDrag = Float(currentState.translation.width)
        }.onEnded { value in
            appModel.onEnded(value: value)
        })
    }
}




struct ProblemContainer<Content: View>: View {
    @EnvironmentObject var appModel: AppViewModel
    
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    
    var _id: Int
    var content: Content
    
    @inlinable public init(
        _id: Int, spacing: CGFloat,
        widthOfHiddenCards: CGFloat,
        cardHeight: CGFloat,
        @ViewBuilder _ content: () -> Content) {
        
        self.content = content()
        self.cardWidth = UIScreen.main.bounds.width - (widthOfHiddenCards * 2) - (spacing * 2)
        self.cardHeight = cardHeight
        self._id = _id
    }
    
    var body: some View {
        content
            .frame(width: cardWidth, height: _id == appModel.activeCard ? cardHeight : cardHeight - 60, alignment: .center)
            .transition(AnyTransition.slide)
            .animation(.spring())
        
    }
}
