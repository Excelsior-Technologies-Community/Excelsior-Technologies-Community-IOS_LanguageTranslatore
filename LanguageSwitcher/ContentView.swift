//
//  ContentView.swift
//  LanguageSwitcher
//
//  Created by Noman belim on 10/12/25.
//
import SwiftUI

struct ContentView: View {
    @ObservedObject var langManager = LanguageManager.shared
     
     var body: some View {
         VStack(spacing: 20) {
             
             // 1. Language Picker
             HStack {
                 Text("Change Language:")
                 Picker("Lang", selection: Binding(
                     get: { langManager.currentLanguage },
                     set: { langManager.setLanguage($0) }
                 )) {
                     ForEach(AppLanguage.allCases) { lang in
                         Text(lang.displayName).tag(lang)
                     }
                 }
             }
             .padding()
             .background(Color.gray.opacity(0.2))
             
             Divider()
             
             // 2. THE USER'S OWN TEXT
             // They just write LiveText and it works instantly
             
             LiveText("Demo Text")
                 .font(.title)
             LiveText("I am going there")
                 .font(.title)
             
             LiveText("My name is noman")
                 .font(.title)
             
             LiveText("This project is amazing because it translates live.")
                 .padding()
             
             LiveText("I can type anything here and it will work.")
                 .foregroundColor(.blue)
             
             Spacer()
         }
     }
 }
#Preview {
    ContentView()
}
