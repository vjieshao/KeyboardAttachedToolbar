//
//  AttachedView.swift
//  KeyboardAttachedToolbar_Example
//
//  Created by 黄杰 on 2021/3/6.
//  Copyright © 2021 3commas. All rights reserved.
//

import UIKit

public class AttachedView<Type: Equatable>: UIView {
    public let type: Type
    public var canSwipeGuesture: Bool
    private weak var showView: UIView?
    
    init(type: Type, canSwipeGuesture: Bool, showView: UIView?) {
        self.type = type
        self.canSwipeGuesture = canSwipeGuesture
        self.showView = showView
        super.init(frame: .zero)
        
        if let showView = showView, !self.subviews.contains(showView) {
            self.addSubview(showView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.showView?.frame = self.bounds
    }
    
    deinit {
        print("CPAttachedView已经移除")
    }
}
