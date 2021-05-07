//
//  AttachedAppearance.swift
//  AppearanceKit_Example
//
//  Created by 黄杰 on 2021/4/7.
//  Copyright © 2021 3commas. All rights reserved.
//

import UIKit

public struct AttachedAppearance {
    
    /// 是否铺满展示输入框附件
    public var isFullToolbarAttached: Bool = false
    
    /// 是否显示线条
    public var isShowLine: Bool = false
    
    /// 线条颜色
    public var lineColor: UIColor? = UIColor(hexString: "#F5F5F5")
    
    /// 切换成AttachedToolbar时，点击超出的区域是否回到键盘输入
    public var isSwitchKeyboardInput: Bool = false
    
    /// 背景颜色
    public var bgColor: UIColor? = UIColor(hexString: "#F8F8FE")
    
    /// 左右间距
    public var spacing: CGFloat = 0.0
    
    /// 垂直间距，默认为垂直居中
    public var verticalSpacing: CGFloat = 0.0
    
    /// item的宽度（只在isFullToolbarAttached为false时有效）
    public var itemWidth: CGFloat = 50.0
    
    public init() {}
}
