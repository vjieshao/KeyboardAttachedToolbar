//
//  UIView+KeyboardAttachedToolbar.swift
//  KeyboardAttachedToolbar_Example
//
//  Created by 黄杰 on 2021/5/7.
//  Copyright © 2021 3commas. All rights reserved.
//

import UIKit

extension UIView {
    
    public var e_left: CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.x
        }
    }
    
    public var e_right: CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue - frame.size.width
            self.frame = frame
        }
        get {
            return self.frame.origin.x + self.frame.size.width
        }
    }
    
    public var e_top: CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.y
        }
    }
    
    public var e_bottom: CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = newValue - frame.size.height
            self.frame = frame
        }
        get {
            return self.frame.origin.y + self.frame.size.height
        }
    }
    
    public var e_centerX: CGFloat {
        set {
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
        get {
            return self.center.x
        }
    }
    
    public var e_centerY: CGFloat {
        set {
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
        get {
            return self.center.y
        }
    }
    
    public var e_width: CGFloat {
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
        get {
            return self.frame.width
        }
    }
    
    public var e_height: CGFloat {
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
        get {
            return self.frame.height
        }
    }
    
    public var e_origin: CGPoint {
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin
        }
    }
    
    public var e_size: CGSize {
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
        get {
            return self.frame.size
        }
    }
}
