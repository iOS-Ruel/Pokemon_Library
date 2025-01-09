//
//  TopIdCloseView.swift
//  Pokemon_Library
//
//  Created by Chung Wussup on 1/9/25.
//


import SwiftUI

struct TopIdCloseView: View {
    var pokeId: Int
    @Environment(\.presentationMode) var presentation
    
    init(pokeId: Int) {
        self.pokeId = pokeId
    }
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 50)
            HStack{
                Text("# \(pokeId)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.gray)
                    .padding(.leading)
                
                Spacer()
                Button{
                    withAnimation(Animation.easeIn(duration: 0.5)) {
                        presentation.wrappedValue.dismiss()
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
}
