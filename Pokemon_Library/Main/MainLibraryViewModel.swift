//
//  MainLibraryViewModel.swift
//  Pokemon_Library
//
//  Created by Chung Wussup on 3/30/24.
//

import Foundation
import Combine

class MainLibraryViewModel: ObservableObject {
    private let apiService = PokeAPIService()
    
    @Published var pokemonSpecies: [Pokemon] = []
    
    var pokeList: PokeLists?
    var pokeSpecies: PokeSpecies?
    
    var pokemonInfo: [PokemonInfo] = []
    var pokemonColor: [String] = []
    var pokemonName: [String] = []
    
    var krTypeNameArr: [TypeName] = []
    var enTypeNameArr: [TypeName] = []
    
    var pokemonInfoText: [flavorText] = []
    
    func getPokemon() async {
        Task {
            do {
                let pokelist = try await apiService.getPokemonList()
                for i in pokelist {
                    let pokeInfo = try await apiService.getPokemonDetail(url: i.url)
                    self.pokemonInfo.append(pokeInfo)
                }
                
                let pokespecies = try await apiService.getPokemonSpecies(allCount: self.pokemonInfo.count)
                self.pokemonColor = pokespecies.map { $0.color.name }
                self.pokemonName = pokespecies.flatMap { $0.names.filter { $0.language.name == "ko" }.map { $0.name } }
                self.pokemonInfoText = pokespecies.compactMap({ $0.flavor_text_entries.filter { $0.language.name == "ko" }.first })
                
                let typeNames = try await apiService.getPokemonTypes(info: self.pokemonInfo)
                self.krTypeNameArr = typeNames.flatMap { $0.names.filter { $0.language.name == "ko" } }
                self.enTypeNameArr = typeNames.flatMap { $0.names.filter { $0.language.name == "en" } }
                
                testFunc()
            } catch {
                print("Error:", error.localizedDescription)
            }
        }
    }
    
    func testFunc() {
        for i in 0..<self.pokemonInfo.count {
            let krNames = Array(krTypeNameArr.prefix(self.pokemonInfo[i].types.count))
            let enNames = Array(enTypeNameArr.prefix(self.pokemonInfo[i].types.count))
            krTypeNameArr.removeSubrange(0..<self.pokemonInfo[i].types.count)
            enTypeNameArr.removeSubrange(0..<self.pokemonInfo[i].types.count)
            
            
            
            
            let pokemon = Pokemon(id: self.pokemonInfo[i].id,
                                  order: self.pokemonInfo[i].order,
                                  name: self.pokemonName[i],
                                  color: self.pokemonColor[i],
                                  height: Double(self.pokemonInfo[i].height)/10,
                                  weight: Double(self.pokemonInfo[i].weight)/10,
                                  krType: krNames,
                                  enType: enNames ,
                                  smallImage: self.pokemonInfo[i].sprites.other.showdown.front_default,
                                  largeImage: self.pokemonInfo[i].sprites.other.showdown.front_default,
                                  pokemonInfoText: self.pokemonInfoText[i].flavor_text
                                  ,
                                  state: self.pokemonInfo[i].stats.filter { $0.stat.name !=  "special-attack" && $0.stat.name !=  "special-defense"}
            )
            DispatchQueue.main.async {
                self.pokemonSpecies.append(pokemon)
            }
        }
    }
}

//class MainLibraryViewModel: ObservableObject {
//    private let apiService = PokeAPIService()
//    
//    var cancellables = Set<AnyCancellable>()
//    
//    @Published var pokemonSpecies: [Pokemon] = []
//    
//    
//    var pokeList: PokeLists?
//    var pokeSpecies: PokeSpecies?
//    
//    var pokemonInfo: [PokemonInfo] = []
//    var pokemonColor: [String] = []
//    var pokemonName: [String] = []
//    
//    var krTypeNameArr: [TypeName] = []
//    var enTypeNameArr: [TypeName] = []
//    
//    let group = DispatchGroup()
//    
//    func getPokemon() {
//        
//        apiService.getPokemonList { pokelist in
//            
//            for i in pokelist {
//                self.group.enter()
//                self.apiService.getPokemonDetail(url: i.url) { pokeInfo in
//                    self.pokemonInfo.append(pokeInfo)
//                    self.group.leave()
//                }
//            }
//            
//            
//            self.group.notify(queue: .main) {
//                self.apiService.getPokemonSpecies(allCount: self.pokemonInfo.count) { pokespecies in
//                    self.pokemonColor = pokespecies.map { $0.color.name }
//                    self.pokemonName = pokespecies.flatMap { $0.names.filter { $0.language.name == "ko" }.map { $0.name } }
//
//                    
//                    self.apiService.getPokemonTypes(info: self.pokemonInfo) { typeNames in
//
//                        self.krTypeNameArr = typeNames.flatMap { $0.names.filter { $0.language.name == "ko" } }
//                        self.enTypeNameArr = typeNames.flatMap { $0.names.filter { $0.language.name == "en" } }
//
//                        self.testFunc()
//                    }
//                    
//                }
//             
//            }
//            
//        }
//        
//    }
//    
//    func testFunc() {
//        
//        for i in 0..<self.pokemonInfo.count {
//            print("\(i) ",pokemonInfo[i].id, pokemonInfo[i].name)
//            
//            let krNames = Array(krTypeNameArr.prefix(self.pokemonInfo[i].types.count))
//            let enNames = Array(enTypeNameArr.prefix(self.pokemonInfo[i].types.count))
//            krTypeNameArr.removeSubrange(0..<self.pokemonInfo[i].types.count)
//            enTypeNameArr.removeSubrange(0..<self.pokemonInfo[i].types.count)
// 
//            let pokemon = Pokemon(id: self.pokemonInfo[i].id, 
//                                  order: self.pokemonInfo[i].order,
//                                  name: self.pokemonName[i],
//                                  color: self.pokemonColor[i],
//                                  height: Double(self.pokemonInfo[i].height)/10,
//                                  weight: Double(self.pokemonInfo[i].weight)/10,
//                                  krType: krNames,
//                                  enType: enNames ,
//                                  smallImage: self.pokemonInfo[i].sprites.other.showdown.front_default,
//                                  largeImage: self.pokemonInfo[i].sprites.other.showdown.front_default)
////            print(pokemon)
////            print("===========")
//            pokemonSpecies.append(pokemon)
//            
//        }
//    }
//    
//}
