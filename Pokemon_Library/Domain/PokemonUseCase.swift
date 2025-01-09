//
//  PokemonUseCase.swift
//  Pokemon_Library
//
//  Created by Chung Wussup on 1/9/25.
//

import Foundation
import Combine

final class PokemonUseCase {
    private let repository: PokemonRepositoryProtocol
    
    init(repository: PokemonRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchPokemon(offset: Int) -> AnyPublisher<[Pokemon], Error> {
        return repository.fetchPokemonList(offset: offset)
            .flatMap { pokeLists in
                self.fetchDetailedPokemonList(from: pokeLists.results)
            }
            .eraseToAnyPublisher()
    }

    private func fetchDetailedPokemonList(from results: [PokeList]) -> AnyPublisher<[Pokemon], Error> {
        let pokemonPublishers = results.map { result in
            self.fetchDetailedPokemon(from: result.url)
        }

        return Publishers.MergeMany(pokemonPublishers)
            .collect()
            .eraseToAnyPublisher()
    }

    private func fetchDetailedPokemon(from url: String) -> AnyPublisher<Pokemon, Error> {
        return repository.fetchPokemonDetail(url: url)
            .flatMap { info in
                self.fetchCompletePokemonInfo(for: info)
            }
            .eraseToAnyPublisher()
    }

    private func fetchCompletePokemonInfo(for info: PokemonInfo) -> AnyPublisher<Pokemon, Error> {
        return repository.fetchPokemonSpecies(id: info.id)
            .flatMap { species in
                self.repository.fetchPokemonTypes(info: info)
                    .map { types in
                        self.convertToPokemon(info: info, species: species, types: types)
                    }
            }
            .eraseToAnyPublisher()
    }

    
    func convertToPokemon(info: PokemonInfo, species: PokeSpecies, types: [TypeNames]) -> Pokemon {
        let color = species.color.name
        let krType = types.flatMap { $0.names.filter { $0.language.name == "ko" } }
        let enType = types.flatMap { $0.names.filter { $0.language.name == "en" } }
        let flavorText = species.flavor_text_entries.first { $0.language.name == "ko" }?.flavor_text ?? ""
        let pokeKrName = species.names.filter { $0.language.name == "ko" }.first?.name ?? ""
        let state = info.stats.filter {
            $0.stat.name != "special-attack"
            && $0.stat.name != "special-defense"}
        
        return Pokemon(
            id: info.id,
            order: info.order,
            name: pokeKrName,
            color: color,
            height: Double(info.height) / 10.0,
            weight: Double(info.weight) / 10.0,
            krType: krType,
            enType: enType,
            pokemonInfoText: flavorText,
            state: state
        )
    }
}
