//
//  LanguageManager.swift
//  LanguageSwitcher
//
//  Created by Noman belim on 10/12/25.
//

import Foundation
import SwiftUI
import Combine

public class LanguageManager: ObservableObject {
    public static let shared = LanguageManager()
    
    @AppStorage("lib_selected_lang") public var currentLanguageCode: String = "en"
    
    // Cache to avoid hitting the network for the same word twice
    private var cache: [String: String] = [:]
    
    private init() {}
    
    public var currentLanguage: AppLanguage {
        return AppLanguage(rawValue: currentLanguageCode) ?? .english
    }
    // LanguageManager.swift
    public func setLanguage(_ language: AppLanguage) {
        self.currentLanguageCode = language.rawValue
        print("Language changed to: \(self.currentLanguageCode)") // <-- ADD THIS
        // Notify UI to refresh
        objectWillChange.send()
    }
    
    // The function LiveText calls
    func getTranslation(for text: String) async -> String {
        let key = "\(text)-\(currentLanguageCode)"
        
        // 1. Check RAM Cache
        if let cached = cache[key] { return cached }
        
        // 2. Perform Network Translation
        let translated = await FreeTranslator.shared.translate(text: text, to: currentLanguageCode)
        
        // 3. Save to Cache
        cache[key] = translated
        return translated
    }
}


public enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case spanish = "es"
    case french = "fr"
    case german = "de"
    case hindi = "hi"
    case japanese = "ja"
    
    public var id: String { self.rawValue }
    
    public var displayName: String {
        switch self {
        case .english: return "English"
        case .spanish: return "Español"
        case .french: return "Français"
        case .german: return "Deutsch"
        case .hindi: return "हिन्दी"
        case .japanese: return "日本語"
        }
    }
}
