//
//  DetailPokeViewModel.swift
//  Pokemon_Library
//
//  Created by Chung Wussup on 3/31/24.
//

import Foundation
import UIKit
import SwiftUI

struct DetailPokeViewModel {
    /*
     상태관리가 필요하다면 UseCase를 주입받아사용해도 될듯
     그러나 Pokemon 객체만 필요할뿐 따로 상태관리가 필요하지 않다고 판단하여
     단순 생성된 Pokemon 사용
     */
    var poke: Pokemon?
        
    init(poke: Pokemon?) {
        self.poke = poke
    }
    
    
    var firstTypeColor: Color? {
        guard let firstValue = poke?.type.first?.rawValue,
                let type = PokemonType(rawValue: firstValue) else  { return nil }
                
        return ThemeColor.typeColor(type: type)
    }
    
    var secondTypeColor: Color? {
        if poke?.type.count ?? 0 > 1 {

            guard let firstValue = poke?.type[1].rawValue,
                    let type = PokemonType(rawValue: firstValue) else  { return nil }
            return ThemeColor.typeColor(type: type)
        }
        return nil
        
    }
    
    
}

