//
//  ContentView.swift
//  LanguageSwitcher
//
//  Created by Noman belim on 10/12/25.
//
import SwiftUI

struct ContentView: View {
    @StateObject var languageManager = LanguageManager.shared
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                
                // --- Language Switcher ---
                HStack {
                    Text("Select:")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(AppLanguage.allCases) { lang in
                                Button(action: {
                                    languageManager.setLanguage(lang)
                                }) {
                                    Text(lang.displayName)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                        .background(languageManager.currentLanguage == lang ? Color.blue : Color.gray.opacity(0.2))
                                        .foregroundColor(languageManager.currentLanguage == lang ? .white : .black)
                                        .cornerRadius(20)
                                }
                            }
                        }
                    }
                }
                .padding()
                
                Divider()
                
                // --- Dynamic Content ---
                VStack(spacing: 20) {
                    // Use LiveText instead of Text
                    LiveText("How are you?")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    LiveText("Welcome")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    
                    // Example Card
                    VStack {
                        Image(systemName: "globe")
                            .font(.system(size: 50))
                            .foregroundColor(.blue)
                            .padding()
                        
                        LiveText("This is a dynamic text")
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(15)
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("Language App")
        }
    }
}
 
#Preview {
    ContentView()
}
