//
//  UIControl+KeyboardAttachedToolbar.swift
//  KeyboardAttachedToolbar_Example
//
//  Created by 黄杰 on 2021/5/7.
//  Copyright © 2021 3commas. All rights reserved.
//

import UIKit

extension UIControl {
    
    @objc func removeButtonHighlightedAction(_ sender: UIButton) {
        if sender.isHighlighted {
            sender.isHighlighted = false
        }
    }
    
    public func removeHighlighted() {
        self.addTarget(self, action: #selector(self.removeButtonHighlightedAction(_:)), for: .allEvents)
    }
}
