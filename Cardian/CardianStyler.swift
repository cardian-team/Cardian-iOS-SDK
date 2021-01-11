//
//  CardianStyler.swift
//  Cardian
//
//  Created by Mitchell Sweet on 9/10/20.
//  Copyright © 2020 Curaegis. All rights reserved.
//

import Foundation
import UIKit

class CardianStyler {
    
    // MARK: Values
    public static let buttonCornerRadius: CGFloat = 15
    
    // MARK: Functions
    public static func styleRoundedButton(button: UIButton, backgroundColor: UIColor = .cardianRed) {
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = buttonCornerRadius
    }
    
}
