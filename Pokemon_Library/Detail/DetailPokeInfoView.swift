//
//  DetailPokeInfoView.swift
//  Pokemon_Library
//
//  Created by Chung Wussup on 3/30/24.
//

import SwiftUI

struct DetailPokeInfoView: View {
    @ObservedObject var viewModel: MainLibraryViewModel
    var animation: Namespace.ID
    
    @State private var isAnimating = false
    @State private var start = false
    @State private var scale: CGFloat = 1.0
    @State private var animationAmount: CGFloat = 1
    @State private var animationCount = 0
    
    var body: some View {
        
        VStack(spacing: 10) {
            self.pokemonInfoView()
        }
        .background(.white)
        .opacity(start ? 1.0 : 0.0)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                start.toggle()
            }
        }
    }
    
    
    func pokemonInfoView() -> some View {
        return ZStack {
            GeometryReader { geometry in
                ZStack() {
                    Circle()
                        .stroke((backgroundView()), lineWidth: 3)
                        .scaleEffect(animationAmount)
                        .opacity(Double(2 - animationAmount))
                        .onAppear {
                            self.animationAmount = 0
                            animateCircle()
                        }
                
                    
                    
                    AsyncImage(url: URL(string: viewModel.selectedPokemon.image)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.5 ,height: geometry.size.width * 0.5)
                            .matchedGeometryEffect(id: viewModel.selectedPokemon.image, in: animation)
                    } placeholder: {
                        ProgressView()
                    }
                    .padding()
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
                    .rotationEffect(.degrees(isAnimating ? randomCount() : 0))
                    .shadow(radius: 8)
                }
                .onTapGesture {
                    self.animationCount = 0
                    self.animate()
                }.background(
                    self.backgroundView()
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                )
            }
            
            
            
            
            VStack(spacing: 10) {
                VStack {
                    Spacer()
                        .frame(height: 10)
                    
                    Text("\(viewModel.selectedPokemon.name)")
                        .font(.system(size: 17, weight: .bold))
                    
                    HStack(spacing: 5) {
                        
                        ForEach((viewModel.selectedPokemon.krType.indices), id: \.self) { index in
                            let type = viewModel.selectedPokemon.krType[index]
                            Text(type.name)
                                .foregroundStyle(.white)
                                .frame(width: 120, height: 25, alignment: .center)
                                .background(
                                    typeBackground(index: index)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    
                    HStack {
                        Text("\(viewModel.selectedPokemon.formattedWeight) KG")
                            .frame(width: 100, height: 25, alignment: .center)
                            .font(.system(.subheadline, design: .default, weight: .bold))
                        
                        Spacer()
                        
                        Text("\(viewModel.selectedPokemon.formattedHeight) M")
                            .frame(width: 100, height: 25, alignment: .center)
                            .font(.system(.subheadline, design: .default, weight: .bold))
                    }
                    .frame(width: 200,alignment: .center)
                    
                    HStack {
                        Text("몸무게")
                            .frame(width: 100, height: 25, alignment: .center)
                            .font(.system(size: 15))
                            .foregroundStyle(.gray)
                        
                        Text("키")
                            .frame(width: 100, height: 25, alignment: .center)
                            .font(.system(size: 15))
                            .foregroundStyle(.gray)
                        
                    }
                    .frame(width: 200, alignment: .center)
                    
                    
                    Spacer()
                        .frame(height: 10)
                }
                .frame(width: 300, alignment: .center)
                .background( RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white) // 배경색 적용
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                        .shadow(color: .gray, radius: 20, x: 0, y: 0)
                )
                .shadow(color: .gray, radius: 20, x: 0, y: 0)
                .padding(EdgeInsets(top: 300, leading: 0, bottom: 0, trailing: 0))
                
                self.infoView()
                
                self.statView()
                Spacer()
            }
            
            
            
            
            VStack {
                Spacer()
                    .frame(height: 50)
                HStack{
                    Text("# \(viewModel.selectedPokemon.id)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.gray)
                        .padding(.leading)
                    
                    Spacer()
                    Button{
                        
                        withAnimation(Animation.easeIn(duration: 0.5)) {
                            viewModel.isDetail.toggle()
                            start.toggle()
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.spring()) {
                                viewModel.isDetail.toggle()
                            }
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.primary)
                    }
                    .padding()
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .padding(.trailing) // 오른쪽 여백 추가
                }
                
                
                Spacer()
                
            }
            .padding(.trailing, 16) // 버튼을 오른쪽 상단에 이동시키기 위한 추가 패딩
            
        }
        .edgesIgnoringSafeArea(.all)
        
        
        
    }
    
    func infoView() -> some View  {
        Text(viewModel.selectedPokemon.pokemonInfoText)
            .font(.system(size: 15, weight: .medium))
        
            .padding()
            .frame(width: 300, alignment: .center)
            .foregroundStyle(.gray)
            .background( RoundedRectangle(cornerRadius: 16)
                .fill(Color.white) // 배경색 적용
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray, lineWidth: 1)
                )
            )
            .shadow(color: .gray, radius: 20, x: 0, y: 0)
    }
    
    func statView() -> some View {
        return VStack {
            
            Text("스탯")
                .foregroundStyle(.gray)
                .font(.system(size: 15, weight: .bold))
                .padding(.top, 10)
            
            //            if let stats = viewModel.selectedPokemon.state {
            ForEach(viewModel.selectedPokemon.state) { stat in
                HorizontalBarChart(data: [Double(stat.base_stat)], color: statBarColor(state: stat.stat.name), title: stat.stat.krName)
                    .foregroundStyle(.clear)
                    .frame(width: 300)
                //                }
            }
        }
        .frame(width: 300, alignment: .center)
        .padding(.bottom, 10)
        .background( RoundedRectangle(cornerRadius: 16)
            .fill(Color.white) // 배경색 적용
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray, lineWidth: 1)
            ))
        .shadow(color: .gray, radius: 20, x: 0, y: 0)
    }
    
    
    func statBarColor(state: String) -> Color {
        switch state {
        case "hp":
            return Color.red
        case "attack":
            return Color.orange
        case "defense":
            return Color.green
        case "speed":
            return Color.yellow
        default :
            return Color.black
        }
    }
    
    func typeBackground(index: Int) -> Color {
        //        if let type = viewModel?.poke?.type[index] {
        return ThemeColor.typeColor(type: viewModel.selectedPokemon.type[index])
        //        } else {
        //            return ThemeColor.typeColor(type: PokemonType.normal)
        //        }
    }
    
    func backgroundView() -> RadialGradient {
        //        if  viewModel?.secondTypeColor != nil {
        RadialGradient(colors: [viewModel.secondTypeColor ?? .white , viewModel.firstTypeColor?.opacity(0.8) ?? .white], center: .bottom, startRadius: 60, endRadius: 300)
        //        } else {
        //            RadialGradient(colors: [ viewModel?.firstTypeColor?.opacity(0.7) ?? .white], center: .bottom, startRadius: 60, endRadius: 300)
        //        }
    }
    
    
    func randomCount() -> Double {
        let countArr: [Double] = [10, -10]
        return countArr.randomElement() ?? 10
    }
    
    func animateCircle() {
        withAnimation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: false)) {
            self.animationAmount = 2 // 애니메이션의 시작점을 설정
        }
    }
    
    func animate() {
        isAnimating = true
        withAnimation(Animation.easeInOut(duration: 0.5)) {
            self.isAnimating.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            if self.animationCount < 2 {
                self.animate()
                self.animationCount += 1
            }
        }
    }
}

//#Preview {
//    DetailPokeInfoView(viewModel:
//                        DetailPokeViewModel(poke:
//                                                Pokemon(id: 1, order: 1,
//                                                        name: "이상해씨", color: "green",
//                                                        height: 7, weight: 0.4,
//                                                        krType: [TypeName(language: LanguageSet(name: "ko", url: ""), name: "풀"), TypeName(language: LanguageSet(name: "ko", url: ""), name: "독")],
//                                                        enType: [TypeName(language: LanguageSet(name: "en", url: ""), name: "grass"),TypeName(language: LanguageSet(name: "en", url: ""), name: "Poison")],
//                                                        smallImage: "", largeImage: "",
//                                                        pokemonInfoText: "ㄴㅅ갸"
//                                                        ,
//                                                        state: [Stats(base_stat: 45, effort: 0, stat: Stat(name: "hp", url: ""))
//                                                                ,Stats(base_stat: 49, effort: 0, stat: Stat(name: "attack", url: ""))
//                                                                ,Stats(base_stat: 49, effort: 0, stat: Stat(name: "defense", url: ""))
//                                                                ,Stats(base_stat: 45, effort: 0, stat: Stat(name: "speed", url: ""))]
//                                                       )
//                                           )
//    )
//}
//
