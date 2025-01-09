//
//  PokeAPIService.swift
//  Pokemon_Library
//
//  Created by Chung Wussup on 3/30/24.
//

import Foundation
import Alamofire
import Combine


enum API {
    case fetchLists(count: Int)
    case fetchDetail(detailUrl: String)
    case fetchSpecies(number: Int)
    case fetchType(typeUrl: String)
    
    var url: URL {
        switch self {
        case .fetchLists(let count):
            return URL(string: "https://pokeapi.co/api/v2/pokemon?offset=\(count)&limit=20")!
        case .fetchDetail(let url):
            return URL(string: "\(url)")!
        case .fetchSpecies(let number):
            return URL(string: "https://pokeapi.co/api/v2/pokemon-species/\(number)")!
        case .fetchType(let url):
            return URL(string: url)!
        }
    }
}
