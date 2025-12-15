 
#   **LiveTranslationKit**

 
#   **Installation (Swift Package Manager)**

Add the package using SPM:

### **Repository URL**

```
https://github.com/Excelsior-Technologies-Community/Excelsior-Technologies-Community-IOS_LanguageTranslatore
```

### Steps

1. Open Xcode
2. Go to **File → Add Packages…**
3. Paste the URL above
4. Choose **Up to Next Major Version**
5. Add to your project

---

#   **Getting Started**

Import the module:

```swift
import SwiftUI
import LiveTranslationKit
```

---

#   **LiveText — Auto-translating Text View**

Use `LiveText` instead of `Text()`:

```swift
LiveText("Hello, how are you?")
```

Whenever the user changes the app’s language, all `LiveText` views automatically:

* Detect language change
* Fetch translated text
* Update smoothly with animation

---

#   **Required: Add a Language Picker to Your App UI**

Every app using this package **must provide a way for users to select a language**.

The recommended method is using a SwiftUI picker.

---

##   **Option 1 — Language Picker (Recommended)**

Add this to your settings screen or app header:

```swift
@ObservedObject var langManager = LanguageManager.shared

Picker("Language", selection: Binding(
    get: { langManager.currentLanguage },
    set: { langManager.setLanguage($0) }
)) {
    ForEach(AppLanguage.allCases) { lang in
        Text(lang.displayName).tag(lang)
    }
}
.pickerStyle(.menu)
```

✔ UI updates instantly
✔ No reload required
✔ Works across all `LiveText` views

---

##   **Option 2 — Language Selector Button (Alternative)**

If you prefer a button instead of a picker:

```swift
@ObservedObject var langManager = LanguageManager.shared

Menu {
    ForEach(AppLanguage.allCases) { lang in
        Button(lang.displayName) {
            langManager.setLanguage(lang)
        }
    }
} label: {
    HStack {
        Image(systemName: "globe")
        Text(langManager.currentLanguage.displayName)
    }
}
```

This creates:

* A button with a globe icon
* A language dropdown menu
* One-tap language switching

---

#   **Full Example (Working Code)**

```swift
struct ContentView: View {
    @ObservedObject var langManager = LanguageManager.shared

    var body: some View {
        VStack(spacing: 20) {

            // Language Picker
            Picker("Language", selection: Binding(
                get: { langManager.currentLanguage },
                set: { langManager.setLanguage($0) }
            )) {
                ForEach(AppLanguage.allCases) { lang in
                    Text(lang.displayName).tag(lang)
                }
            }
            .pickerStyle(.menu)

            // Live Translation
            LiveText("Noman Belim")
            LiveText("Hi, how are you?")
        }
        .padding()
    }
}
```

---

#   **Package Architecture**

| File                    | Purpose                                        |
| ----------------------- | ---------------------------------------------- |
| `LiveText.swift`        | SwiftUI auto-translating Text view             |
| `LanguageManager.swift` | Stores selected language, notifies UI          |
| `FreeTranslator.swift`  | Handles translation via public Google endpoint |

---

#   Network Permissions

Add this if translations fail silently:

```
App Transport Security Settings
    Allow Arbitrary Loads → YES
```

---

#   Supported Languages

Default:

* English (`en`)
* Hindi (`hi`)
* Spanish (`es`)
* French (`fr`)
* German (`de`)
* Japanese (`ja`)

You can add unlimited languages by editing `AppLanguage`.

---

#   Contributions

Improvements and feature additions are welcome.
 
