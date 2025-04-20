//
//  FBLAGAMEApp.swift
//  FBLAGAME
//
//  Created by Venkata Siva Ramisetty on 2/25/25.
//

import SwiftUI

@main
struct FBLAGAMEApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(GameManager()) // Inject GameManager here
        }
    }
}


