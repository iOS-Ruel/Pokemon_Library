//
//  PokemonAPIRepository.swift
//  Pokemon_Library
//
//  Created by Chung Wussup on 1/9/25.
//

import Foundation
import Alamofire
import Combine

// MARK: - Data Layer
final class PokemonAPIRepository: PokemonRepositoryProtocol {
    func fetchPokemonList(offset: Int) -> AnyPublisher<PokeLists, Error> {
        let request = API.fetchLists(count: offset).url
        return performRequest(url: request, responseType: PokeLists.self)
    }

    func fetchPokemonDetail(url: String) -> AnyPublisher<PokemonInfo, Error> {
        let request = API.fetchDetail(detailUrl: url).url
        return performRequest(url: request, responseType: PokemonInfo.self)
    }

    func fetchPokemonSpecies(id: Int) -> AnyPublisher<PokeSpecies, Error> {
        let request = API.fetchSpecies(number: id).url
        return performRequest(url: request, responseType: PokeSpecies.self)
    }

    func fetchPokemonTypes(info: PokemonInfo) -> AnyPublisher<[TypeNames], Error> {
        let typeRequests = info.types.enumerated().map { index, typeInfo in
             fetchPokemonType(url: typeInfo.type.url)
                 .map { (index, $0) }
         }
         
         return Publishers.MergeMany(typeRequests)
             .collect()
             .map { results in
                 results.sorted(by: { $0.0 < $1.0 }).map { $0.1 }
             }
             .eraseToAnyPublisher()
    }

    private func fetchPokemonType(url: String) -> AnyPublisher<TypeNames, Error> {
        let request = API.fetchType(typeUrl: url).url
        return performRequest(url: request, responseType: TypeNames.self)
    }

    private func performRequest<T: Decodable>(url: URL, responseType: T.Type) -> AnyPublisher<T, Error> {
        return AF.request(url)
            .publishDecodable(type: T.self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
