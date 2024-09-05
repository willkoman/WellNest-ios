//
//  ProfileView.swift
//  WellNest
//
//  Created by William Krasnov on 9/4/24.
//


import SwiftUI

struct ProfileView: View {
    @State private var profile: [String: Any] = [:]
    @State private var errorMessage = ""

    var body: some View {
        VStack {
            if let bio = profile["bio"] as? String {
                Text(bio)
            }

            if let goals = profile["goals"] as? String {
                Text(goals)
            }

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .onAppear(perform: loadProfile)
        .padding()
    }

    func loadProfile() {
        APIClient.shared.getProfile { result in
            switch result {
            case .success(let data):
                profile = data
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }
}
