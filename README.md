 
# `LiveTranslationKit` 🌎

A lightweight, SwiftUI-focused library for adding **live, dynamic translation** to your iOS application without requiring an external API key. Perfect for hobby projects, rapid prototyping, and demonstrating live localization features.

### Features

  * **Live Translation:** Instantly translates any string literal (or variable) using an internal, public web service endpoint.
  * **Zero API Key Required:** Uses a public Google service endpoint (for educational/non-enterprise use).
  * **SwiftUI Native:** Provides a simple `LiveText` view that replaces `Text`.
  * **Caching:** Translated phrases are cached to minimize network calls and speed up performance.

-----

## 🚀 Installation (Adding the Dependency)

You can add `LiveTranslationKit` to your project using the Swift Package Manager (SPM).

### Steps:

1.  In Xcode, open your project.
2.  Go to **File** \> **Add Packages...**
3.  In the search bar, paste the URL for this repository:
    ```
    [PASTE YOUR GIT REPOSITORY URL HERE, e.g., https://github.com/nomanbelim/LiveTranslationKit.git]
    ```
4.  Set the **Dependency Rule** to **Up to Next Major Version**.
5.  Click **Add Package**.

-----

## 🛠️ Usage Guide

### 1\. Import the Module

In any Swift file where you use the translation components (like your `ContentView.swift`), you must import the module:

```swift
import SwiftUI
import LiveTranslationKit
```

### 2\. The Language Manager

The `LanguageManager` is the central hub for selecting the active language.

| Property | Description |
| :--- | :--- |
| `LanguageManager.shared` | The singleton instance. |
| `currentLanguage` | The currently selected language (`AppLanguage` enum). |
| `setLanguage(lang: AppLanguage)` | **Crucial:** Call this function to change the language globally. |

**Example: Setting up the Language Picker**

The recommended way to change the language is by binding the picker selection to the `LanguageManager`.

```swift
struct ContentView: View {
    // 1. Observe the shared manager
    @ObservedObject var langManager = LanguageManager.shared 
     
    var body: some View {
        VStack {
            Picker("Language", selection: Binding(
                get: { langManager.currentLanguage },
                set: { langManager.setLanguage($0) }
            )) {
                // Iterate over the included languages
                ForEach(AppLanguage.allCases) { lang in
                    Text(lang.displayName).tag(lang)
                }
            }
            .pickerStyle(.segmented)
            
            Divider()
            
            // ... your LiveText components below
        }
    }
}
```

### 3\. Using `LiveText` (The Magic)

To get live translation for any arbitrary string, simply replace Apple's standard `Text()` view with the `LiveText()` view.

When the language selection changes via the `LanguageManager`, all `LiveText` views will automatically fetch and display the translated content.

```swift
// This text will be translated instantly based on the selected language.
LiveText("I can type anything here and it will work.")
    .font(.title3)

LiveText("My name is noman")
    .foregroundColor(.secondary)
```

-----

## ⚠️ Important Note on Network Security

This package performs network requests in the background. If you encounter errors, you may need to adjust your app's security settings.

If the translation fails silently, you must add the following security exception to your project's **`Info.plist`** file:

| Key | Type | Value |
| :--- | :--- | :--- |
| `App Transport Security Settings` | Dictionary | |
| ↳ `Allow Arbitrary Loads` | Boolean | `YES` |

This ensures iOS does not block the requests to the public Google translation endpoint.

-----

*Enjoy your new live translation feature\!*
