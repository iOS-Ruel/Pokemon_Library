//
//  MainLibraryViewModel.swift
//  Pokemon_Library
//
//  Created by Chung Wussup on 3/30/24.
//

import Foundation
import Combine
import SwiftUI

class MainLibraryViewModel: ObservableObject {
    @Published var selectedPokemon: Pokemon!
    @Published var showProgress : Bool = false

    var subsciptions = Set<AnyCancellable>()
    
    
    var pokemonLists: PokeLists?
    
    @Published var pokemonArr: [Pokemon] = []
    func fetchListAndThenDetail(_ fetchCount: Int = 0) {
        self.showProgress = true
        ApiService.fetchListAndThenDetail(fetchCount)
                .flatMap { pokeList -> AnyPublisher<Pokemon, Error> in
                    return ApiService.fetchSpecies(number: pokeList.id)
                        .flatMap { species -> AnyPublisher<Pokemon, Error> in
                            
                            let id = pokeList.id
                            let order = pokeList.order
                            let color = species.color.name
                            let name = species.names.filter { $0.language.name == "ko" }.first?.name ?? ""
                            let height = Double(pokeList.height) / 10
                            let weight = Double(pokeList.height) / 10
                            let infoText = species.flavor_text_entries.filter { $0.language.name == "ko" }.first?.flavor_text ?? "정보 없음"
                            let state = pokeList.stats.filter { $0.stat.name != "special-attack" && $0.stat.name !=  "special-defense" }
                            
                            return ApiService.fetchTypes(info: pokeList)
                                .map { types -> Pokemon in
                                    
                                    let krNameArr = types.flatMap({ $0.names.filter{$0.language.name == "ko"} })
                                    let enNameArr =  types.flatMap({ $0.names.filter{$0.language.name == "en"} })
                                    
                                    let pokemon = Pokemon(id: id, order: order, name: name, color: color, height:  height, weight: weight, krType: krNameArr, enType: enNameArr,  pokemonInfoText: infoText, state: state)
                                    
                                    return pokemon
                                }
                                .eraseToAnyPublisher()
                        }
                        .eraseToAnyPublisher()
                }
                .collect()
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("All requests finished")
                        
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                } receiveValue: { pokemons in
                    // 모든 Pokemon을 받았으므로 정렬할 수 있음
                    let sortedPokemons = pokemons.sorted { $0.id < $1.id }
                    // 정렬된 Pokemons를 사용하거나 저장
                    self.pokemonArr.append(contentsOf: sortedPokemons)
                    self.showProgress = false
                }
                .store(in: &subsciptions)
    }
    
    
    var firstTypeColor: Color? {
        guard let firstValue = selectedPokemon.type.first?.rawValue, let type = PokemonType(rawValue: firstValue) else  { return nil }
        
        return ThemeColor.typeColor(type: type)
    }
    
    var secondTypeColor: Color? {
        if selectedPokemon.type.count > 1 {
            guard let type = PokemonType(rawValue: selectedPokemon.type[1].rawValue) else {
                return nil
            }
            return ThemeColor.typeColor(type: type)
            
            
        }
        return nil
        
    }
    
    
    
}
