//
//  spotify_cloneApp.swift
//  spotify_clone
//
//  Created by Kieran Reid on 06/09/2024.
//

import SwiftUI

@main
struct spotify_cloneApp: App {
    @StateObject var playingSongViewModel = PlayingSongViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(playingSongViewModel)
        }
    }
}
