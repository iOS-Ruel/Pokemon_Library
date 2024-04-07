//
//  MainLibraryView.swift
//  Pokemon_Library
//
//  Created by Chung Wussup on 3/30/24.
//

import SwiftUI

struct MainLibraryView: View {
    @ObservedObject private var viewModel = MainLibraryViewModel()
    @Namespace var animation
    @State private var showModal = false
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: columns){
                        ForEach(viewModel.pokemonSpecies, id: \.id) { poke in
                            MainLibraryListRow(poke: poke, viewModel: viewModel)
                                .onTapGesture {
                                    print(poke.name)
                                    self.showModal = true
                                    viewModel.selectedPokemon = poke
                                }
                                .fullScreenCover(isPresented: $showModal, content: {
                                    DetailPokeInfoView(viewModel: DetailPokeViewModel(poke: viewModel.selectedPokemon))
                                })
                                .onAppear {
                                    if viewModel.pokemonSpecies.count > 1 && !viewModel.pokemonSpecies.isEmpty && poke == viewModel.pokemonSpecies.last {
                                        print("마지막 셀입니다.")
                                        print(viewModel.isLoading)
                                        Task {
                                            
                                            viewModel.isFirst = false
                                            viewModel.pokemonCnt += 20
                                            await viewModel.getPokemon()
                                        }
                                    }
                                }
                        }
                        
                      
                    }
                }
                .navigationTitle("포켓몬 도감")
            }
            if viewModel.showProgress {

                ProgressView("loading ... ")
                    .onAppear{
                        print("loading")
                    }
                
            }

        }
        .onAppear {
            Task {
                if viewModel.pokemonSpecies.isEmpty {
                    viewModel.isFirst = true
                    await viewModel.getPokemon()
                }
            }
        }
    }
}

#Preview {
    MainLibraryView()
}


