//
//  Constants.swift
//  GameOfLife
//
//  Created by Praveen V on 11/05/25.
//

import CoreFoundation
import SwiftUICore
import SwiftUI

enum StoredUserDefaults: String {
    case SpeedSliderValue
}

class Constants {
    struct Colors {
        static let alive: Color = .alive
        static let dead: Color = .white
        static let close: Color = .red
        static let pause: Color = .lime
    }
    
    struct Dimensions {
        static let cellSize: CGFloat = 20
        static let buttonSize: Int = 60
        static let closeButtonSize: Int = 50
        static let closeButtonOffset: Int = 15
    }
    
    static let defaultSpeedSliderValue: Float = 0.5
}
