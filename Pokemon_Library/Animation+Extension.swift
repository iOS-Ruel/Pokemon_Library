//
//  Animation+Extension.swift
//  Pokemon_Library
//
//  Created by Chung Wussup on 3/30/24.
//

import Foundation
import SwiftUI

extension Animation {
    static func shakeEffect() -> Animation {
         Animation.spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0.5)
             .repeatCount(3, autoreverses: true)
             .speed(5)
     }
}
