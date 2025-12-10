//
//  LiveText.swift
//  LanguageSwitcher
//
//  Created by Noman belim on 10/12/25.
//

import Foundation
import SwiftUI

// Make struct public if it's part of a module/library
public struct LiveText: View {
    let originalText: String
    @State private var displayedText: String = "" // Initialize state properly
    
    // Use ObservedObject to listen to changes
    @ObservedObject private var manager = LanguageManager.shared
    
    public init(_ text: String) {
        self.originalText = text
        // Set initial displayed text to the original text
        self._displayedText = State(initialValue: text)
    }
    
    public var body: some View {
        Text(displayedText)
            // Use the published language code (String) for the ID
            .id(manager.currentLanguageCode) // FIX for line 34: Use the String property!
            
            // Trigger a new task whenever the language code changes
            .task(id: manager.currentLanguageCode) { // FIX for line 34: Use the String property!
                await translate()
            }
            .onAppear {
                Task { await translate() }
            }
    }
    
    private func translate() async {
        // ... (rest of the function)
        // ...
        
        let result = await manager.getTranslation(for: originalText)
        
        await MainActor.run {
            withAnimation {
                self.displayedText = result
            }
        }
    }
}
