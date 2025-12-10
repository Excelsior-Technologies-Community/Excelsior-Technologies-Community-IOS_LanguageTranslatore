//
//  FreeTranslator.swift
//
//  Internal helper to handle network calls for live translation.
//

import Foundation

// Internal helper to handle network calls
class FreeTranslator {
    static let shared = FreeTranslator()
    
    // This is a known public endpoint used for web compatibility.
    private let baseURL = "https://translate.googleapis.com/translate_a/single"
    
    // Prevent external initialization
    private init() {}
    
    func translate(text: String, to targetLang: String) async -> String {
        // If text is empty or target is English, return original
        guard !text.isEmpty, targetLang != "en" else { return text }
        
        // CRITICAL FIX 1: URL encode the input text to prevent 400 errors
        let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? text
        
        // Prepare URL
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "client", value: "gtx"),
            URLQueryItem(name: "sl", value: "auto"),
            URLQueryItem(name: "tl", value: targetLang),
            URLQueryItem(name: "dt", value: "t"),
            URLQueryItem(name: "q", value: encodedText) // Use the Encoded Text
        ]
        
        guard let url = components.url else {
            print("[\(targetLang)] Translator Error: Failed to create URL.")
            return text
        }
        
        print("[\(targetLang)] Attempting translation for: '\(text)'")
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                guard httpResponse.statusCode == 200 else {
                    print("[\(targetLang)] Translator Error: HTTP Status Code \(httpResponse.statusCode)")
                    return text
                }
            }
            
            // CRITICAL FIX 2 & 3: Robust JSON Parsing and URL Decoding
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                var fullTranslation = ""
                
                if let translationChunks = jsonArray.first as? [Any] {
                    for chunk in translationChunks {
                        // Concatenate all translation fragments
                        if let textParts = chunk as? [Any],
                           let translatedText = textParts.first as? String {
                            fullTranslation += translatedText
                        }
                    }
                }
                
                if !fullTranslation.isEmpty {
                    let tempCleanText = fullTranslation.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    // 🛑 FINAL FIX: Remove URL encoding (e.g., convert %20 back to ' ')
                    let finalDecodedText = tempCleanText.removingPercentEncoding ?? tempCleanText
                    
                    print("[\(targetLang)] SUCCESS: Final Decoded Text: '\(finalDecodedText)'")
                    return finalDecodedText
                }
            }
            
            print("[\(targetLang)] Translator Error: JSON Parsing failed or structure was unexpected.")
            
        } catch {
            print("[\(targetLang)] Translator Error: Network Request failed with error: \(error.localizedDescription)")
        }
        
        return text // Fallback to original on any failure
    }
}
