//
//  PokemonUseCaseProtocol.swift
//  Pokemon_Library
//
//  Created by Chung Wussup on 1/13/25.
//

import Foundation
import Combine

protocol PokemonUseCaseProtocol {
    func fetchPokemon(offset: Int) -> AnyPublisher<[Pokemon], Error>
}
