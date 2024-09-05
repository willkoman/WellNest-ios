//
//  Item.swift
//  WellNest
//
//  Created by William Krasnov on 9/4/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
