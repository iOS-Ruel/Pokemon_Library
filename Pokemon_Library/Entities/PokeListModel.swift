//
//  PokeListModel.swift
//  Pokemon_Library
//
//  Created by Chung Wussup on 1/8/25.
//

import Foundation

//https://pokeapi.co/api/v2/pokemon
struct PokeLists: Codable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [PokeList]
}

struct PokeList: Codable {
    let name: String
    let url: String
}
