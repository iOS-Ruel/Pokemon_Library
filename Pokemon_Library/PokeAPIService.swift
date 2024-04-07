//
//  PokeAPIService.swift
//  Pokemon_Library
//
//  Created by Chung Wussup on 3/30/24.
//

import Foundation
import Alamofire

struct ApiConstants {
    static let getAllPokemon = "https://pokeapi.co/api/v2/pokemon?offset="
    static let getDetailPokemon = "https://pokeapi.co/api/v2/pokemon/"
}

class PokeAPIService {
    var pokemons: [Pokemon] = []

    func getPokemonList(nextUrl: String, pokemonCnt: Int = 0) async throws -> PokeLists {
        let url = "https://pokeapi.co/api/v2/pokemon?offset=\(pokemonCnt)&limit=20"
        
        guard let url = URL(string: url) else {
             throw URLError(.badURL)
         }
         
         let (data, _) = try await URLSession.shared.data(from: url)
         let pokeLists = try JSONDecoder().decode(PokeLists.self, from: data)
        
         return pokeLists
    }
    
    func getPokemonDetail(url: String) async throws -> PokemonInfo {
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let pokemonInfo = try JSONDecoder().decode(PokemonInfo.self, from: data)
        
        return pokemonInfo
    }

    func getPokemonSpecies(starCnt: Int,allCount: Int) async throws -> [PokeSpecies] {
        var speciesArray: [PokeSpecies] = []
        let dispatchGroup = DispatchGroup()
        
        for i in starCnt...allCount {
            dispatchGroup.enter()
            let url = URL(string: "https://pokeapi.co/api/v2/pokemon-species/\(i)")!
            
            let (data, _) = try await URLSession.shared.data(from: url)
            let species = try JSONDecoder().decode(PokeSpecies.self, from: data)
            speciesArray.append(species)
            
            dispatchGroup.leave()
        }
        
        return speciesArray
    }

    func getPokemonTypes(info: [PokemonInfo]) async throws -> [TypeNames] {
        var typeNamesArray: [TypeNames] = []
        let dispatchGroup = DispatchGroup()
        
        for pokemonInfo in info {
            for type in pokemonInfo.types {
                dispatchGroup.enter()
                let url = URL(string: type.type.url)!
                
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    let typeNames = try JSONDecoder().decode(TypeNames.self, from: data)
                    typeNamesArray.append(typeNames)
                } catch {
                    print("getPokemonTypes:", error.localizedDescription)
                }
                
                dispatchGroup.leave()
            }
        }
        
        return typeNamesArray
    }
    
    
    
    func jsonPrint<T: Encodable>(data: T){
        do {
            let jsonData = try JSONEncoder().encode(data)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
            }
        } catch {
            print("Error encoding data: \(error)")
        }
    }
    
    
    
}
