//
//  APIManagerView.swift
//  iSchedule
//
//  Created by Esmatullah Akhtari on 29/9/2023.
//

import SwiftUI
/**
 `APIManager` is responsible for fetching motivational quotes from an API and decoding them into a format suitable for display in your app.
 
 ## Overview:
 APIManager contains a function to fetch motivational quotes from an external API and a struct to represent the quotes. The main purpose is to provide motivational quotes to the `StatisticView` or any other part of your app where they are displayed.
 
 ## Usage:
 To use the `APIManagerView` in your SwiftUI view, follow these steps:
 1. Create an instance of `QuoteModel`.
 2. Call the `fetchQuotes(quoteModel:)` function with the instance of `QuoteModel` as a parameter.
 3. Access the motivational quotes from the `quotes` property of the `QuoteModel` instance.
 
 Here's an example of how to use it:
 ```swift
 let quoteModel = QuoteModel()
 fetchQuotes(quoteModel: quoteModel)
 let quotes = quoteModel.quotes
 ```
 
 ## Body:
 `APIManager` primarily consists of a function and a struct for fetching and managing motivational quotes from a remote API.
 
 ##Function:
 `fetchQuotes(quoteModel:)`: This function performs an API request to fetch motivational quotes and updates the provided QuoteModel instance with the fetched quotes
 
 ##Struct:
 `Quote`: This struct represents a single motivational quote. It contains two properties: q for the quote text and a for the author's name.
**/
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
