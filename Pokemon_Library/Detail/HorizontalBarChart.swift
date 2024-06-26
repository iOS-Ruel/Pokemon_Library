//
//  HorizontalBarChart.swift
//  Pokemon_Library
//
//  Created by Chung Wussup on 4/3/24.
//

import SwiftUI


struct HorizontalBarChart: View {
    let data: [Double]
    let maxValue: Double = 252
    let color: Color
    let title: String
    @State private var rectangleWidth: CGFloat = 0
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            Spacer()
                .frame(width: 10)
            
            pokeStatTitleView()
            
            Spacer()
                .frame(width: 20)
            
            pokeStatView()
            
            Spacer()
                .frame(width: 10)

        }
    }
    
    func pokeStatTitleView() -> some View {
        Text(title)
            .font(.system(size: 15))
            .frame(width: 40)
            .foregroundStyle(.gray)
    }
    
    
    func pokeStatView() -> some View {
        ForEach(data, id: \.self) { value in
            ZStack {
                ZStack(alignment: .leading) {
                    pokeBaseStatValueView()
                    
                    pokeStatValueView(value: value)
                }
                
                Text("\(Int(value)) / \(Int(maxValue))")
                    .foregroundColor(.black)
                    .font(.caption2)
            }
        }
        .frame(width: 150)
    }
    
    func pokeBaseStatValueView() -> some View {
        Capsule()
            .strokeBorder(.black, lineWidth: 1)
            .background(.clear)
            .frame(width: 180, height: 20)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    func pokeStatValueView(value: Double) -> some View {
        Capsule()
            .background(color)
            .frame(width: rectangleWidth, height: 18)
            .clipped()
            .clipShape(Capsule())
            .padding(1)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.0)) {
                    rectangleWidth = (CGFloat(value / maxValue) * 180) - 2
                }
            }
    }
    
}



#Preview {
    HorizontalBarChart(data: [252], color: .black, title: "공격력")
}
