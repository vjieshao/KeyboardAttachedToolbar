//
//  AttachedItem.swift
//  KeyboardAttachedToolbar_Example
//
//  Created by 黄杰 on 2021/3/6.
//  Copyright © 2021 3commas. All rights reserved.
//

import UIKit

public struct Appearance {

    public static let screenW = UIScreen.main.bounds.width

    public static let screenH = UIScreen.main.bounds.height

    /// 使用计算型属性，不能使用存储型属性，这样可以让他每次都计算，而不会导致状态栏隐藏时，statusBarH返回0
    public static var statusBarH: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }

    public static let navigationBarH: CGFloat = 44.0

    public static var navigationH: CGFloat {
        return navigationBarH + statusBarH
    }

    public static let tabBarHeight: CGFloat = {
        let root = (UIApplication.shared.keyWindow?.rootViewController as? UITabBarController)
        let tabBarH: CGFloat = root == nil ? 0.0 : 49.0
        return (safeBottomHeight != 0.0) ? (safeBottomHeight + tabBarH) : tabBarH
    }()

    public static var safeTopHeight: CGFloat {
        var safeTopSpacing: CGFloat = 0.0
        if let top = UIApplication.shared.keyWindow?.safeAreaInsets.top, top != 0.0 {
            safeTopSpacing = top
        } else if let top = UIApplication.shared.windows.first?.safeAreaInsets.top, top != 0.0 {
            safeTopSpacing = top
        }
        return safeTopSpacing
    }

    public static var safeBottomHeight: CGFloat {
        var safeBottomSpacing: CGFloat = 0.0
        if let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom, bottom != 0.0 {
            safeBottomSpacing = bottom
        } else if let bottom = UIApplication.shared.windows.first?.safeAreaInsets.bottom, bottom != 0.0 {
            safeBottomSpacing = bottom
        }
        return safeBottomSpacing
    }

    /// 是否是全面屏/刘海屏
    public static var isFullScreen: Bool {
        return safeBottomHeight > 0
    }
}

public typealias EmptyBlock = (() -> Void)
public typealias AttachedClickedBlock = (() -> Void)?

public struct AttachedItem<Type: Equatable> {
    var button: AttachedButton<Type>
    var customView: UIView?
    var clickBlock: AttachedClickedBlock?
    var returnBlock: (() -> Bool)?
    
    public init(button: AttachedButton<Type>, customView: UIView? = nil, clickBlock: AttachedClickedBlock? = nil, returnBlock: (() -> Bool)? = nil) {
        self.button = button
        self.customView = customView
        self.clickBlock = clickBlock
        self.returnBlock = returnBlock
    }
}
