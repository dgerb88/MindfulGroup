//
//  QuoteController.swift
//  mindfulness
//
//  Created by Brayden Lemke on 3/4/24.
//

import Foundation


///  Quote Controller allows for fetching a single quote.
///     Per the advice of the quote api being used, we fetch 50 quotes and store those quotes. We then use those 50 quotes until we run out and then fetch for 50 more quotes.
struct QuoteController {
    private static var quoteContainer: QuoteContainer?
    private static let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("quotes.json")
    private static let apiURL = "https://zenquotes.io/api/quotes"
    
    static func getQuote() async throws -> Quote? {
        // Quotes are already loaded into memory
        if let quoteContainer {
            return try await getQuote(quoteContainer: quoteContainer)
        }
        
        // Fetch quotes from file system
        if let quoteContainer = loadSavedQuotes() {
            self.quoteContainer = quoteContainer
            return try await getQuote(quoteContainer: quoteContainer)
        }
        
        // No quotes in memory so load some in from the API
        if let quoteContainer = try await fetchNewQuotes() {
            self.quoteContainer = quoteContainer
            return try await getQuote(quoteContainer: quoteContainer)
        }
        
        // Something went wrong with the API. Shouldn't be possible to get this far. An error should be thrown beforehand.
        return nil
    }
    
    
    // It is assumed that before this function is called. self.quoteContainer has been given a value.
    private static func getQuote(quoteContainer: QuoteContainer) async throws -> Quote {
        let newQuote = quoteContainer.quotes[quoteContainer.currIndex]
        self.quoteContainer?.currIndex += 1
        
        // Reached the end of the array so get new quotes for later
        if self.quoteContainer!.currIndex >= quoteContainer.quotes.count, let newQuoteContainer = try await fetchNewQuotes() {
            self.quoteContainer = newQuoteContainer
        }
        
        saveQuotes(quoteContainer: self.quoteContainer!)
        
        return newQuote
    }
    
    private static func fetchNewQuotes() async throws -> QuoteContainer? {
        // Initialize our session and url
        let session = URLSession.shared
        let url = URLComponents(string: "\(apiURL)")!
        
        let request = URLRequest(url: url.url!)
        
        var data: Data
        var response: URLResponse
        
        do {
            let (httpData, httpResponse) = try await session.data(for: request)
            data = httpData
            response = httpResponse
        } catch {
            print(error)
            throw error
        }
       
        
        // Ensure we had a good response (status 200)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("Quote API came back with non 200 status code")
            throw QuoteError.Non200Error
        }
        
        let decoder = JSONDecoder()
        let quotes = try? decoder.decode([Quote].self, from: data)
        
        if let quotes {
            return QuoteContainer(currIndex: 0, quotes: quotes)
        }
        
        throw QuoteError.DecodingError
    }
    
    private static func loadSavedQuotes() -> QuoteContainer? {
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let jsonDecoder = JSONDecoder()
            let quoteContainer = try? jsonDecoder.decode(QuoteContainer.self, from: jsonData)
            return quoteContainer
        } catch {
            print("No saved quotes or an error occured")
            return nil
        }
    }
    
    private static func saveQuotes(quoteContainer: QuoteContainer) {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(quoteContainer)
            try jsonData.write(to: fileURL, options: .noFileProtection)
        } catch {
            print("Error saving quotes")
        }
    }
    
    enum QuoteError: Error {
        case Non200Error
        case DecodingError
    }
}
