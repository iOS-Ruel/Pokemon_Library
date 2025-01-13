//
//  MainLibraryViewModel.swift
//  Pokemon_Library
//
//  Created by Chung Wussup on 3/30/24.
//

import Foundation
import Combine
import SwiftUI

// Use Case로 모든 비지니스 로직을 담당하게 하고
// ViewModel은 Use Case의 결과만 가지고 UI에 전달하는 역할 수행

final class MainLibraryViewModel: ObservableObject {
    @Published var selectedPokemon: Pokemon?
    @Published var showProgress: Bool = false
    @Published var pokemonArr: [Pokemon] = []

    private let usecase: PokemonUseCaseProtocol
    private var subscriptions = Set<AnyCancellable>()
    private var fetchCount: Int = 0

    init(usecase: PokemonUseCaseProtocol) {
        self.usecase = usecase
    }

    func fetchListAndThenDetail() {
        self.showProgress = true
        
        usecase.fetchPokemon(offset: fetchCount)
            .sink { completion in
                self.showProgress = false
                switch completion {
                case .finished:
                    print("Fetch completed successfully.")
                case .failure(let error):
                    print("Error fetching data: \(error)")
                }
            } receiveValue: { pokemons in
                self.pokemonArr.append(contentsOf: pokemons.sorted(by: {$0.id < $1.id}))
            }
            .store(in: &subscriptions)
    }

    func checkLast(_ last: Pokemon?) {
        if pokemonArr.count > 1
            && last == pokemonArr.last {
            fetchCount += 20
            fetchListAndThenDetail()
        } else if pokemonArr.isEmpty{
            fetchListAndThenDetail()
        }
    }

    var firstTypeColor: Color? {
        guard let firstValue = selectedPokemon?.type.first?.rawValue,
              let type = PokemonType(rawValue: firstValue) else {
            return nil
        }
        return ThemeColor.typeColor(type: type)
    }

    var secondTypeColor: Color? {
        guard let selectedPokemon = selectedPokemon, selectedPokemon.type.count > 1 else {
            return nil
        }
        return ThemeColor.typeColor(type: PokemonType(rawValue: selectedPokemon.type[1].rawValue) ?? .normal)
    }
}
