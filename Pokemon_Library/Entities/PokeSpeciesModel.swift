//
//  PokeSpeciesModel.swift
//  Pokemon_Library
//
//  Created by Chung Wussup on 1/8/25.
//

import Foundation


//https://pokeapi.co/api/v2/pokemon-species/1
struct PokeSpecies: Codable {
    let color: SpeciesColor
    let names: [SpeciesName]
    let flavor_text_entries: [flavorText]
}

struct flavorText: Codable {
    let flavor_text: String
    let language: LanguageSet
}

struct SpeciesColor: Codable{
    let name: String
    let url: String
}

struct SpeciesName: Codable{
    let language: SpeciesLanguage
    let name: String
}

struct SpeciesLanguage:Codable {
    let name: String
    let url: String
}


struct TypeNames: Codable {
    let names: [TypeName]
}

struct TypeName: Codable, Hashable {
    let language: LanguageSet
    let name: String
    
    func hash(into hasher: inout Hasher) {
         hasher.combine(language)
         hasher.combine(name)
     }
     
     static func == (lhs: TypeName, rhs: TypeName) -> Bool {
         return lhs.language == rhs.language && lhs.name == rhs.name
     }
}

struct LanguageSet: Codable, Hashable {
    let name: String
    let url: String
}
