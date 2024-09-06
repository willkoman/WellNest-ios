//
//  Theme.swift
//  WellNest
//
//  Created by William Krasnov on 9/5/24.
//


import SwiftUI

struct Theme {
    var backgroundColor: Color
    var primaryTextColor: Color
    var secondaryTextColor: Color
    var buttonBackgroundColor: Color
    var buttonTextColor: Color
    var accentColor: Color
    var borderColor: Color
    var buttonBackgroundColorSecondary: Color
    var buttonTextColorSecondary: Color
}

extension Theme {
    // Default pastel blue theme
    static let pastelBlue = Theme(
        backgroundColor: Color(hex: "E3F2FD"),
        primaryTextColor: Color(hex: "0D47A1"),
        secondaryTextColor: Color(hex: "42A5F5"),
        buttonBackgroundColor: Color(hex: "64B5F6"),
        buttonTextColor: .white,
        accentColor: Color(hex: "90CAF9"),
        borderColor: Color(hex: "BBDEFB"),
        buttonBackgroundColorSecondary: Color(hex: "0D47A1"),
        buttonTextColorSecondary: .white
    )
}

extension Color {
    // Helper function to convert hex color string to SwiftUI Color
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var hexNumber: UInt64 = 0
        scanner.scanHexInt64(&hexNumber)
        let r = Double((hexNumber & 0xff0000) >> 16) / 255
        let g = Double((hexNumber & 0x00ff00) >> 8) / 255
        let b = Double(hexNumber & 0x0000ff) / 255
        self.init(red: r, green: g, blue: b)
    }
}

import Combine

class ThemeManager: ObservableObject {
    @Published var currentTheme: Theme = .pastelBlue  // Default theme is pastel blue
    
    func changeTheme(to newTheme: Theme) {
        currentTheme = newTheme
    }
}
