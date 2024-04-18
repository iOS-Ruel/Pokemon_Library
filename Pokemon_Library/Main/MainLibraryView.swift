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
    
    
    @State private var count = 0
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: columns){
                        ForEach(viewModel.pokemonArr, id: \.id) { poke in
                            
                            
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
                                    
                                    
                                    if viewModel.pokemonArr.count > 1 && !viewModel.pokemonArr.isEmpty && poke == viewModel.pokemonArr.last {
                                        self.count += 20
                                        viewModel.fetchListAndThenDetail(self.count)
   
                                        
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
            if viewModel.pokemonArr.isEmpty {
                viewModel.fetchListAndThenDetail()
            }

        }
    }
}

#Preview {
    MainLibraryView()
}


