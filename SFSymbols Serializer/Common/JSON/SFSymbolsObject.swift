//
//  SFSymbolsObject.swift
//  Icon Studio
//
//  Created by Ashley Chapman on 20/06/2022.
//

import Foundation
import Combine

class SFSymbolsObject: BaseViewModel, Codable {
    
    enum CodingKeys: CodingKey {
        case items
    }
    
    // Variables
    @Published var items: [SFSymbolItem] = []

    init(items: [SFSymbolItem] = []) {
        self.items = items
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.items, forKey: .items)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.items = try container.decodeIfPresent([SFSymbolItem].self, forKey: .items)!
    }
}
