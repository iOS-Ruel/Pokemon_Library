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

enum ApiService {
    static func fetchList(_ fetchCount: Int = 0) -> AnyPublisher<PokeLists, Error> {
        return AF.request(API.fetchLists(count: fetchCount).url)
            .publishDecodable(type: PokeLists.self)
            .value()
            .mapError { aferror in
                return aferror as Error
            }
            .eraseToAnyPublisher()
    }
    
    static func fetchListAndThenDetail(_ fetchCount: Int = 0) -> AnyPublisher<PokemonInfo, Error> {
        return fetchList()
            .flatMap { pokeList in
                Publishers.MergeMany(pokeList.results.map { fetchDetail(url:$0.url) })
            }
            .eraseToAnyPublisher()
            
    }
    
    static func fetchDetail(url: String) -> AnyPublisher<PokemonInfo,Error> {
        return AF.request(API.fetchDetail(detailUrl: url).url)
            .publishDecodable(type: PokemonInfo.self)
            .value()
            .mapError { afError in
                return afError as Error
            }
            .eraseToAnyPublisher()
        
    }
    
    static func fetchSpecies(number: Int) -> AnyPublisher<PokeSpecies, Error> {
        return AF.request(API.fetchSpecies(number: number).url)
            .publishDecodable(type: PokeSpecies.self)
            .value()
            .mapError { afError in
                return afError as Error
            }
            .eraseToAnyPublisher()
    }
    
//    static func fetchType(info: PokemonInfo) -> AnyPublisher<TypeNames, Error> {
////        print(info.types.first!.type.url)
////        print("=====")
//        print(#function ,info.types)
//        
//        return AF.request(API.fetchType(typeUrl: info.types.first!.type.url).url)
//            .publishDecodable(type: TypeNames.self)
//            .value()
//            .mapError { afError in
//                return afError as Error
//            }
//            .eraseToAnyPublisher()
//    }
    
    static func fetchTypes(info: PokemonInfo) -> AnyPublisher<[TypeNames], Error> {
        let typeRequests = info.types.map { typeInfo in
            fetchType(info: info, typeUrl: typeInfo.type.url)
        }
        return Publishers.MergeMany(typeRequests)
            .collect()
            .eraseToAnyPublisher()
    }

    static func fetchType(info: PokemonInfo, typeUrl: String) -> AnyPublisher<TypeNames, Error> {
        return AF.request(API.fetchType(typeUrl: typeUrl).url)
            .publishDecodable(type: TypeNames.self)
            .value()
            .mapError { afError in
                return afError as Error
            }
            .eraseToAnyPublisher()
    }
}



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
