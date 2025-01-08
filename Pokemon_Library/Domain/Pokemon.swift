//
//  Pokemon.swift
//  Pokemon_Library
//
//  Created by Chung Wussup on 1/8/25.
//

import Foundation

struct Pokemon: Codable, Equatable {
    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int
    let order: Int
    let name: String
    let color: String
    let height: Double
    let weight: Double
    var krType: [TypeName]
    var enType: [TypeName]
  
    let pokemonInfoText: String
    let state: [Stats]
    
    var formattedHeight: String {
        return String(format: "%.1f", height)
    }
    
    var formattedWeight: String {
        return String(format: "%.1f", weight)
    }
    
    var type: [PokemonType] {
        return enType.map { PokemonType(rawValue: $0.name.lowercased()) ?? .normal }
    }
    
    var image: String {
        return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
    }
}
