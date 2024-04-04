//
//  MainLibraryView.swift
//  Pokemon_Library
//
//  Created by Chung Wussup on 3/30/24.
//

import SwiftUI

struct MainLibraryView: View {
    
    @ObservedObject private var viewModel = MainLibraryViewModel()
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, content: {
                    ForEach(viewModel.pokemonSpecies, id: \.id) { poke in
                        NavigationLink(destination: DetailPokeInfoView(viewModel: DetailPokeViewModel(poke: poke))) {
                            MainLibraryListRow(poke: poke)
                        }
                        
                    }
                })
                
            }
            .navigationTitle("포켓몬 도감") // 네비게이션 타이틀 추가
            .onAppear {
                Task {
                    if viewModel.pokemonSpecies.isEmpty {
                        await viewModel.getPokemon()
                    }
                }
            }
        }
    }
}

#Preview {
    MainLibraryView()
}


