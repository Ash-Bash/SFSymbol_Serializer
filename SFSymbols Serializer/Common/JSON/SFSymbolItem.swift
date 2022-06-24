//
//  SFSymbolItem.swift
//  Icon Studio
//
//  Created by Ashley Chapman on 20/06/2022.
//

import Foundation

class SFSymbolItem: BaseViewModel, Codable, Identifiable {
    
    enum CodingKeys: CodingKey {
        case id, symbol, category, isVariable, isMonochrome, isHierarchial, isPalette, isMulticolour, isLimited
    }
    
    // Variables
    @Published var id: UUID?
    @Published var symbol: String
    @Published var category: SFSymbolCategory
    @Published var isVariable: Bool
    @Published var isMonochrome: Bool = true
    @Published var isHierarchical: Bool
    @Published var isPalette: Bool
    @Published var isMulticolour: Bool
    @Published var isLimited: Bool
    
    init(id: UUID?, symbol: String, category: SFSymbolCategory, isVariable: Bool, isMonochrome: Bool = true, isHierarchical: Bool, isPalette: Bool, isMulticolour: Bool, isLimited: Bool) {
        self.id = id
        self.symbol = symbol
        self.category = category
        self.isVariable = isVariable
        self.isMonochrome = isMonochrome
        self.isHierarchical = isHierarchical
        self.isPalette = isPalette
        self.isMulticolour = isMulticolour
        self.isLimited = isLimited
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.id, forKey: .id)
        try container.encode(self.symbol, forKey: .symbol)
        try container.encode(self.category, forKey: .category)
        try container.encode(self.isVariable, forKey: .isVariable)
        try container.encode(self.isMonochrome, forKey: .isMonochrome)
        try container.encode(self.isHierarchical, forKey: .isHierarchial)
        try container.encode(self.isMulticolour, forKey: .isMulticolour)
        try container.encode(self.isPalette, forKey: .isPalette)
        try container.encode(self.isLimited, forKey: .isLimited)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id)!
        self.symbol = try container.decodeIfPresent(String.self, forKey: .symbol)!
        self.category = try container.decodeIfPresent(SFSymbolCategory.self, forKey: .category)!
        self.isVariable = try container.decodeIfPresent(Bool.self, forKey: .isVariable)!
        self.isMonochrome = try container.decodeIfPresent(Bool.self, forKey: .isMonochrome)!
        self.isHierarchical = try container.decodeIfPresent(Bool.self, forKey: .isHierarchial)!
        self.isPalette = try container.decodeIfPresent(Bool.self, forKey: .isPalette)!
        self.isMulticolour = try container.decodeIfPresent(Bool.self, forKey: .isMulticolour)!
        self.isLimited = try container.decodeIfPresent(Bool.self, forKey: .isLimited)!
    }
}

