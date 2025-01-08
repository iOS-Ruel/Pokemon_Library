//
//  PokemonDetail.swift
//  Pokemon_Library
//
//  Created by Chung Wussup on 3/30/24.
//

import Foundation


//https://pokeapi.co/api/v2/pokemon

//struct PokeLists: Codable {
//    var count: Int
//    var next: String?
//    var previous: String?
//    var results: [PokeList]
//}
//
//struct PokeList: Codable {
//    let name: String
//    let url: String
//}


//https://pokeapi.co/api/v2/pokemon/1/

//struct PokemonInfo: Codable {
//    let forms: [Forms]
//    let height: Int
//    let id: Int
//    let name: String
//    let order: Int
//    let species: Species
//    let stats: [Stats]
//    let types: [Types]
//    let weight: Int
//}
//
//struct Forms: Codable {
//    let name: String
//    let url: String
//}
//
//struct Species: Codable {
//    let name: String
//    let url: String
//}
//
//
//
//struct Stats: Codable, Identifiable {
//    let id = UUID()
//    
//    let base_stat: Int
//    let effort: Int
//    let stat: Stat
//}
//
//
//struct Types: Codable {
//    let slot: Int
//    let type: PokeTypes
//}
//
//struct PokeTypes: Codable {
//    let name: String
//    let url: String
//}
//
//struct Stat: Codable {
//    let name: String
//    let url: String
//    
//    
//    var krName: String {
//        return StatKrName(rawValue: name)?.krName ?? ""
//    }
//}


//struct Showdown: Codable {
//    let front_default: String?
//}


////https://pokeapi.co/api/v2/pokemon-species/1
//struct PokeSpecies: Codable {
//    let color: SpeciesColor
//    let names: [SpeciesName]
//    let flavor_text_entries: [flavorText]
//}
//
//struct flavorText: Codable {
//    let flavor_text: String
//    let language: LanguageSet
//}
//
//struct SpeciesColor: Codable{
//    let name: String
//    let url: String
//}
//struct SpeciesName: Codable{
//    let language: SpeciesLanguage
//    let name: String
//}
//
//struct SpeciesLanguage:Codable {
//    let name: String
//    let url: String
//}
//
//
//struct TypeNames: Codable {
//    let names: [TypeName]
//}
//struct TypeName: Codable, Hashable {
// 
//    let language: LanguageSet
//    let name: String
//    
//    func hash(into hasher: inout Hasher) {
//         hasher.combine(language)
//         hasher.combine(name)
//     }
//     
//     static func == (lhs: TypeName, rhs: TypeName) -> Bool {
//         return lhs.language == rhs.language && lhs.name == rhs.name
//     }
//}
//
//struct LanguageSet: Codable, Hashable {
//    let name: String
//    let url: String
//}
//
//struct Pokemon: Codable, Equatable {
//    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
//        return lhs.id == rhs.id
//    }
//    
//    let id: Int
//    let order: Int
//    let name: String
//    let color: String
//    let height: Double
//    let weight: Double
//    var krType: [TypeName]
//    var enType: [TypeName]
//  
//    let pokemonInfoText: String
//    let state: [Stats]
//    
//    var formattedHeight: String {
//        return String(format: "%.1f", height)
//    }
//    var formattedWeight: String {
//        return String(format: "%.1f", weight)
//    }
//    var type: [PokemonType] {
//        return enType.map { PokemonType(rawValue: $0.name.lowercased()) ?? .normal }
//    }
//    
//    var image: String {
//        return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
//    }
//}
//
//
//enum StatKrName: String {
//    case hp
//    case attack
//    case defense
//    case speed
//    
//    var krName: String {
//        switch self {
//        case .hp:
//            return "체력"
//        case .defense:
//            return "방어력"
//        case .attack:
//            return "공격력"
//        case .speed:
//            return "속도"
//        }
//    }
//}
