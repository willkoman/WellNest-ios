//
//  Helpers.swift
//  WellNest
//
//  Created by William Krasnov on 9/5/24.
//

//function to convert from string date to english formatted: ie 12th January 2024

import Foundation

func convertToEnglishFormat(date: String) -> String {
//    print(date)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    let date = dateFormatter.date(from: date)
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMMM yyyy"
    return formatter.string(from: date ?? Date())
}
