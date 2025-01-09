//
//  PokemonRepositoryProtocol.swift
//  Pokemon_Library
//
//  Created by Chung Wussup on 1/8/25.
//

import Foundation
import Combine

// MARK: - Domain Layer
protocol PokemonRepositoryProtocol {
    func fetchPokemonList(offset: Int) -> AnyPublisher<PokeLists, Error>
    func fetchPokemonDetail(url: String) -> AnyPublisher<PokemonInfo, Error>
    func fetchPokemonSpecies(id: Int) -> AnyPublisher<PokeSpecies, Error>
    func fetchPokemonTypes(info: PokemonInfo) -> AnyPublisher<[TypeNames], Error>
}
