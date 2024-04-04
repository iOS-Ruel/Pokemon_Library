//
//  PokeAPIService.swift
//  Pokemon_Library
//
//  Created by Chung Wussup on 3/30/24.
//

import Foundation
import Alamofire

struct ApiConstants {
    static let getAllPokemon = "https://pokeapi.co/api/v2/pokemon?limit=20"
    static let getDetailPokemon = "https://pokeapi.co/api/v2/pokemon/"
}

class PokeAPIService {
    var pokemons: [Pokemon] = []

    func getPokemonList() async throws -> [PokeList] {
        guard let url = URL(string: ApiConstants.getAllPokemon) else {
             throw URLError(.badURL)
         }
         
         let (data, _) = try await URLSession.shared.data(from: url)
         let pokeLists = try JSONDecoder().decode(PokeLists.self, from: data)
         
         return pokeLists.results
    }
    
    func getPokemonDetail(url: String) async throws -> PokemonInfo {
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let pokemonInfo = try JSONDecoder().decode(PokemonInfo.self, from: data)
        
        return pokemonInfo
    }

    func getPokemonSpecies(allCount: Int) async throws -> [PokeSpecies] {
        var speciesArray: [PokeSpecies] = []
        let dispatchGroup = DispatchGroup()
        
        for i in 1...allCount {
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
    
    
    
//    func getPokemonList(completion: @escaping ([PokeList]) -> Void) {
//        AF.request(ApiConstants.getAllPokemon, method: .get).responseDecodable(of: PokeLists.self) { response in
//            switch response.result {
//            case .success(let pokeLists):
//                completion(pokeLists.results)
//            case .failure(let error):
//                print("getPokemonList", error.localizedDescription)
//            }
//        }
//    }
//    
//    func getPokemonDetail(url: String, completion: @escaping (PokemonInfo) -> Void) {
//        AF.request(url, method: .get).responseDecodable(of: PokemonInfo.self) { response in
//            switch response.result {
//            case .success(let pokemonInfo):
//                completion(pokemonInfo)
//            case .failure(let error):
//                print("getPokemonDetail", error.localizedDescription)
//            }
//        }
//    }
//    
//    func getPokemonSpecies(allCount: Int, completion: @escaping ([PokeSpecies]) -> Void) {
//        var speciesArray: [PokeSpecies] = []
//        
//        let group = DispatchGroup()
//        
//        for i in 1...allCount {
//            group.enter()
//            AF.request("https://pokeapi.co/api/v2/pokemon-species/\(i)", method: .get).responseDecodable(of: PokeSpecies.self) { response in
//                defer { group.leave() }
//                
//                switch response.result {
//                case .success(let species):
//                    speciesArray.append(species)
//                case .failure(let error):
//                    print("getPokemonSpecies:", error.localizedDescription)
//                }
//            }
//        }
//        
//        group.notify(queue: .main) {
//            completion(speciesArray)
//        }
//    }
//    
//    func getPokemonTypes(info: [PokemonInfo], completion: @escaping ([TypeNames]) -> Void) {
//        var typeNamesArray: [TypeNames] = []
//        
//        let group = DispatchGroup()
//        
//        for pokemonInfo in info {
//            for type in pokemonInfo.types {
//                group.enter()
//                AF.request(type.type.url, method: .get).responseDecodable(of: TypeNames.self) { response in
//                    defer { group.leave() }
//                    
//                    switch response.result {
//                    case .success(let typeNames):
//                        typeNamesArray.append(typeNames)
//                    case .failure(let error):
//                        print("getPokemonTypes:", error.localizedDescription)
//                    }
//                }
//            }
//        }
//        
//        group.notify(queue: .main) {
//            completion(typeNamesArray)
//        }
//    }

    
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
