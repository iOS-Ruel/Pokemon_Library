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
    static func fetchList(_ fetchCount: Int) -> AnyPublisher<PokeLists, Error> {
        return AF.request(API.fetchLists(count: fetchCount).url)
            .publishDecodable(type: PokeLists.self)
            .value()
            .mapError { aferror in
                return aferror as Error
            }
            .eraseToAnyPublisher()
    }
    
    static func fetchListAndThenDetail(_ fetchCount: Int = 0) -> AnyPublisher<PokemonInfo, Error> {
        return fetchList(fetchCount)
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


class PokeAPIService {
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
