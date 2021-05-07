//
//  AttachedButton.swift
//  KeyboardAttachedToolbar_Example
//
//  Created by 黄杰 on 2021/3/6.
//  Copyright © 2021 3commas. All rights reserved.
//

import UIKit

public class AttachedButton<Type: Equatable>: UIButton {
    public let type: Type
    public var canSwipeGuesture: Bool
    private var icon: UIImage?
    private var iconHighlighted: UIImage?
    private var iconDisabled: UIImage?
    
    public init(type: Type, canSwipeGuesture: Bool = false, icon: UIImage? = nil, iconHighlighted: UIImage? = nil, iconDisabled: UIImage? = nil) {
        self.type = type
        self.canSwipeGuesture = canSwipeGuesture
        self.icon = icon
        self.iconHighlighted = iconHighlighted
        self.iconDisabled = iconDisabled
        super.init(frame: .zero)
        
        self.removeHighlighted()
        if let icon = icon {
            self.setImage(icon, for: .normal)
        }
        if let iconHighlighted = iconHighlighted {
            self.setImage(iconHighlighted, for: .selected)
        }
        if let iconDisabled = iconDisabled {
            self.setImage(iconDisabled, for: .disabled)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
