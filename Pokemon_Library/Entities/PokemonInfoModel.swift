//
//  PokemonInfoModel.swift
//  Pokemon_Library
//
//  Created by Chung Wussup on 1/8/25.
//

import Foundation

//https://pokeapi.co/api/v2/pokemon/1/
struct PokemonInfo: Codable {
    let forms: [Forms]
    let height: Int
    let id: Int
    let name: String
    let order: Int
    let species: Species
    let stats: [Stats]
    let types: [Types]
    let weight: Int
}

struct Forms: Codable {
    let name: String
    let url: String
}

struct Species: Codable {
    let name: String
    let url: String
}

struct Stats: Codable, Identifiable {
    var id = UUID()
    
    let base_stat: Int
    let effort: Int
    let stat: Stat
    
    private enum CodingKeys: String, CodingKey {
        case base_stat, effort, stat
    }
}

struct Types: Codable {
    let slot: Int
    let type: PokeTypes
}

struct PokeTypes: Codable {
    let name: String
    let url: String
}

struct Stat: Codable {
    let name: String
    let url: String
    
    var krName: String {
        return StatKrName(rawValue: name)?.krName ?? ""
    }
}


enum StatKrName: String {
    case hp
    case attack
    case defense
    case speed
    
    var krName: String {
        switch self {
        case .hp:
            return "체력"
        case .defense:
            return "방어력"
        case .attack:
            return "공격력"
        case .speed:
            return "속도"
        }
    }
}
