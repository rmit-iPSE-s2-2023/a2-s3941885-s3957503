//
//  APIManagerView.swift
//  iSchedule
//
//  Created by Esmatullah Akhtari on 29/9/2023.
//

import SwiftUI

import SwiftUI

func fetchQuotes(quoteModel: QuoteModel) {
    if let url = URL(string: "https://zenquotes.io/api/random") {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let decodedQuotes = try JSONDecoder().decode([Quote].self, from: data)
                    DispatchQueue.main.async {
                        quoteModel.quotes = decodedQuotes
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            } else if let error = error {
                print("Error: \(error)")
            }
        }.resume()
    }
}

struct Quote: Codable, Hashable {
    let q: String
    let a: String
}
