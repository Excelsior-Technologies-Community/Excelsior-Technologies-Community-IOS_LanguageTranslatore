//
//  LocalizationManager.swift
//  LanguageSwitcher
//
//  Created by Noman belim on 10/12/25.
//
import Foundation
import SwiftUI

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case spanish = "es"
    case french = "fr"
    case german = "de"
    case hindi = "hi"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .spanish: return "Español"
        case .french: return "Français"
        case .german: return "Deutsch"
        case .hindi: return "हिन्दी"
        }
    }
}
struct LiveText: View {
    var text: String
    @State private var translatedText: String
    // Listen to the manager
    @ObservedObject var languageManager = LanguageManager.shared
    
    init(_ text: String) {
        self.text = text
        self._translatedText = State(initialValue: text)
    }
    
    var body: some View {
        Text(translatedText)
            .onAppear {
                updateText()
            }
            // Trigger update when language changes
            .onChange(of: languageManager.currentLanguage) { _ in
                withAnimation {
                    updateText()
                }
            }
    }
    
    private func updateText() {
        // Ask our "Service" to translate
        let translation = TranslationService.shared.translate(text, to: languageManager.currentLanguage)
        self.translatedText = translation
    }
}
class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @AppStorage("selectedLanguage") private var savedLanguage: String = "en"
    @Published var currentLanguage: AppLanguage
    
    init() {
        self.currentLanguage = AppLanguage(rawValue: UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en") ?? .english
    }
    
    func setLanguage(_ language: AppLanguage) {
        // 1. Update State
        self.currentLanguage = language
        self.savedLanguage = language.rawValue
        
        // 2. Override Apple System Language (UserDefaults)
        // This tricks standard iOS components (like DatePicker) to change language
        UserDefaults.standard.set([language.rawValue], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        // 3. Post notification to update Views
        NotificationCenter.default.post(name: Notification.Name("LanguageChanged"), object: nil)
    }
}
class TranslationService {
    static let shared = TranslationService()
    
    // A dictionary [LanguageCode : [EnglishText : TranslatedText]]
    private let database: [String: [String: String]] = [
        "es": [ // Spanish
            "How are you?": "¿Cómo estás?",
            "Welcome": "Bienvenido",
            "Change Language": "Cambiar idioma",
            "This is a dynamic text": "Este es un texto dinámico"
        ],
        "fr": [ // French
            "How are you?": "Comment allez-vous?",
            "Welcome": "Bienvenue",
            "Change Language": "Changer de langue",
            "This is a dynamic text": "Ceci est un texte dynamique"
        ],
        "de": [ // German
            "How are you?": "Wie geht es dir?",
            "Welcome": "Willkommen",
            "Change Language": "Sprache ändern",
            "This is a dynamic text": "Dies ist ein dynamischer Text"
        ],
        "hi": [ // Hindi
            "How are you?": "आप कैसे हैं?",
            "Welcome": "स्वागत है",
            "Change Language": "भाषा बदलें",
            "This is a dynamic text": "यह एक गतिशील पाठ है"
        ]
    ]
    
    func translate(_ text: String, to language: AppLanguage) -> String {
        if language == .english { return text }
        
        // Try to find the translation in our "Fake API" database
        if let langDict = database[language.rawValue],
           let translated = langDict[text] {
            return translated
        }
        
        // Fallback: If not found, just return original text (or add a * mark to show it's missing)
        return text + " (*)"
    }
}
