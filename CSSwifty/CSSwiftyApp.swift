//
//  CSSwiftyApp.swift
//  CSSwifty
//
//  Created by Michael Osuji on 6/29/21.
//

import SwiftUI

@main
struct CSSwiftyApp: App {
    @StateObject var appModel = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(appModel)
        }
    }
}
