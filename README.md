# SFSymbol_Serializer
*Requires macOS 13 Beta+*

SFSymbol Serializer is a Application writen in Swift & SwiftUI that allows Developers to create entries that you can copy / add SFSymbols to a List, 
set certain properties (allow for filtering in apps) and Serializes them into a JSON File.

Here are the Codable Files for Serialization:


**SFSymbolObject.Swift:**
```
  struct SFSymbolsObject: Codable {
    
    // Variables
    var items: [SFSymbolItem]
}
```

**SFSymbolItem.Swift:**

```
  struct SFSymbolItem: Codable {
    
    // Variables
    var symbol: String
    var category: SFSymbolCategory
    var isVariable: Bool
    var isMonochrome: Bool = true
    var isHierarchical: Bool
    var isPalette: Bool
    var isMulticolour: Bool
    var isLimited: Bool
}

```

**SFSymbolsCategory.Swift:**

```
  enum SFSymbolCategory: String, Codable {
    case none = "None"
    case communication
    case weather
    case objectsAndTools = "Objects and Tools"
    case devices
    case cameraAndPhotos = "Camera and Photos"
    case gaming
    case connectivity
    case transport
    case accessibility
    case privacyAndSecurity = "Privacy and Security"
    case human
    case home
    case fitness
    case nature
    case editing
    case textFormatting = "Text Formatting"
    case media
    case keyboard
    case commerce
    case time
    case health
    case shapes
    case arrows
    case indices
    case maths
}
```
