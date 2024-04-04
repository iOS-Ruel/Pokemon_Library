//
//  MainLibraryListRow.swift
//  Pokemon_Library
//
//  Created by Chung Wussup on 3/30/24.
//

import SwiftUI

struct MainLibraryListRow: View {
    var poke: Pokemon
    
    var body: some View {
        VStack(spacing: 5) {
            AsyncImage(url: URL(string: poke.image)) { image in
                image
                    .resizable()
                    .renderingMode(.original)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 150, height: 150, alignment: .center)
            .background(ThemeColor.typeColor(type: poke.type.first ?? .normal).opacity(0.7)) // 배경에 색상 적용
            .clipShape(RoundedRectangle(cornerRadius: 10)) // 배경도 원형으로 클립
            
            HStack {
                Text("No.\(poke.id)")
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .frame(width: 150,alignment: .center)
            
            HStack {
                Text("\(poke.name)")
                    .foregroundColor(.black)
                Spacer()
            }
            .frame(width: 150,alignment: .center)
            
            
            
            
            HStack(spacing: 5) {
                
                ForEach(poke.krType.indices, id: \.self) { index in
                    let type = poke.krType[index]
                    Text(type.name)
                        .foregroundStyle(.white)
                        .frame(width: 75, height: 25, alignment: .center)
                    
                        .background(ThemeColor.typeColor(type: poke.type[index]))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    if poke.krType.count == 1 {
                        Spacer()
                    }
                }
                
            }
            .frame(width: 150,alignment: .center)
        }
        .onAppear {
            
         
            //            print(poke.id, poke.name, poke.krType)
            //            print(poke.type)
            //            print(poke.enType)
            //            print("=============")
        }
        
    }
}

#Preview {
    MainLibraryListRow(poke:
                        Pokemon(id: 1, order: 1,
                                name: "이상해씨", color: "green",
                                height: 7, weight: 0.4,
                                krType: [TypeName(language: LanguageSet(name: "ko", url: ""), name: "풀"), TypeName(language: LanguageSet(name: "ko", url: ""), name: "독")],
                                enType: [TypeName(language: LanguageSet(name: "en", url: ""), name: "grass"),TypeName(language: LanguageSet(name: "en", url: ""), name: "Poison")],
                                smallImage: "", largeImage: "",
                                pokemonInfoText: "ㄴㅅ갸"
                                ,
                               state: []
                               )
    )
    
}




