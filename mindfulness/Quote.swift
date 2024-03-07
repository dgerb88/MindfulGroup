//
//  Quote.swift
//  mindfulness
//
//  Created by Brayden Lemke on 3/4/24.
//

import Foundation
struct Quote: Codable {
    var a: String
    var q: String
}

struct QuoteContainer: Codable {
    var currIndex: Int
    var quotes: [Quote]
}
