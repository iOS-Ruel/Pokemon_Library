//
//  DetailPokeViewModel.swift
//  Pokemon_Library
//
//  Created by Chung Wussup on 3/31/24.
//

import Foundation
import UIKit
import SwiftUI

struct DetailPokeViewModel {
    var poke: Pokemon?
        
    init(poke: Pokemon?) {
        self.poke = poke
    }
    
    
    var firstTypeColor: Color? {
        guard let firstValue = poke?.type.first?.rawValue, let type = PokemonType(rawValue: firstValue) else  { return nil }
                
        return ThemeColor.typeColor(type: type)
    }
    
    var secondTypeColor: Color? {
        if poke?.type.count ?? 0 > 1 {

            guard let firstValue = poke?.type[1].rawValue, let type = PokemonType(rawValue: firstValue) else  { return nil }
            return ThemeColor.typeColor(type: type)
        }
        return nil
        
    }
    
    
}
