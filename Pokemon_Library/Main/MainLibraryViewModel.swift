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
    @Published var isDetail = false
    @Published var pokemonSpecies: [Pokemon] = []
    
    var isFirst = true
    var pokemonCnt = 0
    
    private let apiService = PokeAPIService()
    
    var pokeLists: PokeLists?
    var pokeSpecies: PokeSpecies?
    
    var pokemonInfo: [PokemonInfo] = []
    var pokemonColor: [String] = []
    var pokemonName: [String] = []
    
    var krTypeNameArr: [TypeName] = []
    var enTypeNameArr: [TypeName] = []
    
    var pokemonInfoText: [flavorText] = []
    var typeNames: [flavorText] = []
    
    
    @Published var isLoading : Bool = false
    @Published var showProgress : Bool = false
    
    func getPokemon() async throws {
        DispatchQueue.main.async {
            self.showProgress = true
        }
        
        if !isLoading {
            pokeLists = try await apiService.getPokemonList( nextUrl: pokeLists?.next ?? ApiConstants.getAllPokemon, pokemonCnt: pokemonCnt)
            
            if let list = pokeLists?.results {
                for i in list {
                    do {
                        let pokeInfo = try await apiService.getPokemonDetail(url: i.url)
                        self.pokemonInfo.append(pokeInfo)
                    } catch {
                        print("Error fetching Pokemon detail:", error)
                    }
                }
            }
            
            let pokespecies = try await apiService.getPokemonSpecies(starCnt: pokemonCnt + 1, allCount: self.pokemonInfo.count)
            
            self.pokemonColor.append(contentsOf: pokespecies.map { $0.color.name })
            self.pokemonName.append(contentsOf: pokespecies.flatMap { $0.names.filter { $0.language.name == "ko" }.map { $0.name } })
            self.pokemonInfoText.append(contentsOf:pokespecies.compactMap({ $0.flavor_text_entries.filter { $0.language.name == "ko" }.first }))
            
            let typeNames = try await apiService.getPokemonTypes(info: self.pokemonInfo)
            
            self.krTypeNameArr = typeNames.flatMap { $0.names.filter { $0.language.name == "ko" } }
            self.enTypeNameArr = typeNames.flatMap { $0.names.filter { $0.language.name == "en" } }
            
            testFunc()
            
        }
        
    }
    
    
    var count: Int = 0
    func testFunc() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        for i in pokemonCnt..<self.pokemonInfo.count {
            count += self.pokemonInfo[i].types.count
            
            let pokemon = Pokemon(id: self.pokemonInfo[i].id,
                                  order: self.pokemonInfo[i].order,
                                  name: self.pokemonName[i],
                                  color: self.pokemonColor[i],
                                  height: Double(self.pokemonInfo[i].height)/10,
                                  weight: Double(self.pokemonInfo[i].weight)/10,
                                  krType: Array(krTypeNameArr.prefix(count).suffix(self.pokemonInfo[i].types.count)),
                                  enType: Array(enTypeNameArr.prefix(count).suffix(self.pokemonInfo[i].types.count)),
                                  pokemonInfoText: self.pokemonInfoText[i].flavor_text,
                                  state: self.pokemonInfo[i].stats.filter { $0.stat.name !=  "special-attack" && $0.stat.name !=  "special-defense"}
            )
            
            DispatchQueue.main.async {
                self.pokemonSpecies.append(pokemon)
            }
            
        }
        DispatchQueue.main.async {
            self.isLoading = false
            self.showProgress = false
        }
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
    
    var subsciptions = Set<AnyCancellable>()
    
    
    var pokemonLists: PokeLists?
    
    @Published var pokemonArr: [Pokemon] = []
    func fetchListAndThenDetail(_ fetchCount: Int = 0) {
        self.showProgress = true
        ApiService.fetchListAndThenDetail(fetchCount)
                .flatMap { pokeList -> AnyPublisher<Pokemon, Error> in
                    return ApiService.fetchSpecies(number: pokeList.id)
                        .flatMap { species -> AnyPublisher<Pokemon, Error> in
                            print(pokeList)
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
    
}
