//
//  MainLibraryView.swift
//  Pokemon_Library
//
//  Created by Chung Wussup on 3/30/24.
//

import SwiftUI

struct MainLibraryView: View {
    @ObservedObject private var viewModel: MainLibraryViewModel
    @State private var showModal: Bool = false

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    init(viewModel: MainLibraryViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(viewModel.pokemonArr, id: \ .id) { poke in
                            MainLibraryListRow(poke: poke, viewModel: viewModel)
                                .onTapGesture {
                                    print(poke.name)
                                    self.showModal = true
                                    viewModel.selectedPokemon = poke
                                }
                                .fullScreenCover(isPresented: $showModal) {
                                    DetailPokeInfoView(viewModel: DetailPokeViewModel(poke: viewModel.selectedPokemon))
                                }
                                .onAppear {
                                    viewModel.checkLast(poke)
                                }
                        }
                    }
                }
                .navigationTitle("포켓몬 도감")
            }

            if viewModel.showProgress {
                ProgressView("로딩중...")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                    .controlSize(.large)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.black.opacity(0.6))
            }
        }
        .onAppear {
            viewModel.checkLast(nil)
        }
    }
}


#Preview {
    MainLibraryView(viewModel: MainLibraryViewModel(usecase: PokemonUseCase(repository: PokemonAPIRepository())))
}


