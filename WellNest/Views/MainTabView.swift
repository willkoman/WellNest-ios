//
//  MainTabView.swift
//  WellNest
//
//  Created by William Krasnov on 9/5/24.
//


import SwiftUI

struct MainTabView: View {
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        TabView {
            // Tracker View Tab
            TrackerView()
                .tabItem {
                    Image(systemName: "figure.walk")
                    Text("Tracker")
                }

            // Data View Tab
            DataView()
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                    Text("Data")
                }
            
            // Feed View Tab (Middle)
            FeedView()
                .tabItem {
                    Image(systemName: "text.bubble")
                    Text("Feed")
                }
            
            // Profile View Tab
            ProfileView(viewModel: viewModel)  // Use the ProfileView you already created
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }

            // Settings View Tab
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
    }
}
