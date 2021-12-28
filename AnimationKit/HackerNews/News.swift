//
//  News.swift
//  AnimationKit
//
//  Created by Ferdinand on 28/12/21.
//

import Foundation

typealias NewsId = [Int]

// MARK: - MainMenu
struct NewsItem: Codable {
    let by: String?
    let descendants, id: Int?
    let kids: [Int]?
    let score, time: Int?
    let title, type: String?
    let url: String?
}

