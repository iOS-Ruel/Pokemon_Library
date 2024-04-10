//
//  ThemeColor.swift
//  Pokemon_Library
//
//  Created by Chung Wussup on 3/31/24.
//

import UIKit
import SwiftUI

enum PokemonType: String {
    case normal
    case fighting
    case flying
    case poison
    case ground
    case rock
    case bug
    case ghost
    case steel
    case fire
    case water
    case grass
    case psychic
    case ice
    case dragon
    case dark
    case fairy
}


struct ThemeColor {
    static let primary = UIColor(hexString: "D21312")
    static let normal = UIColor(hexString: "D8D9DA")
    static let fighting = UIColor(hexString: "F28705")
    static let flying = UIColor(hexString: "95C8FF")
    static let poison = UIColor(hexString: "9652D9")
    static let ground = UIColor(hexString: "AA7939")
    static let rock = UIColor(hexString: "BCB889")
    static let bug = UIColor(hexString: "9FA423")
    static let ghost = UIColor(hexString: "6E4570")
    static let steel = UIColor(hexString: "6AAED3")
    static let fire = UIColor(hexString: "FF612B")
    static let water = UIColor(hexString: "2892FF")
    static let grass = UIColor(hexString: "47BF26")
    static let electric = UIColor(hexString: "F2CB05")
    static let psychic = UIColor(hexString: "FF637F")
    static let ice = UIColor(hexString: "62DFFF")
    static let dragon = UIColor(hexString: "5462D6")
    static let dark = UIColor(hexString: "4F4747")
    static let fairy = UIColor(hexString: "FFB1FF")
    
    static func typeColor(type: PokemonType) -> Color {
        switch type {
        case .normal:
            return Color(ThemeColor.normal)
        case .fighting:
            return Color(ThemeColor.fighting)
        case .flying:
            return Color(ThemeColor.flying)
        case .poison:
            return Color(ThemeColor.poison)
        case .ground:
            return Color(ThemeColor.ground)
        case .rock:
            return Color(ThemeColor.rock)
        case .bug:
            return Color(ThemeColor.bug)
        case .ghost:
            return Color(ThemeColor.ghost)
        case .steel:
            return Color(ThemeColor.steel)
        case .fire:
            return Color(ThemeColor.fire)
        case .water:
            return Color(ThemeColor.water)
        case .grass:
            return Color(ThemeColor.grass)
        case .psychic:
            return Color(ThemeColor.psychic)
        case .ice:
            return Color(ThemeColor.ice)
        case .dragon:
            return Color(ThemeColor.dragon)
        case .dark:
            return Color(ThemeColor.dark)
        case .fairy:
            return Color(ThemeColor.fairy)
        }
    }
}

