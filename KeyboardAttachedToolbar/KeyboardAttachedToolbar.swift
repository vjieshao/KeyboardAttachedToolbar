//
//  KeyboardAttachedToolbar.swift
//  KeyboardAttachedToolbar_Example
//
//  Created by 黄杰 on 2021/5/7.
//  Copyright © 2021 3commas. All rights reserved.
//

import UIKit
import KeyboardMan
import SnapKit

public class KeyboardAttachedToolbar<Type: Equatable>: UIView {
    
    public var didPhotoFoldCompletedAction: EmptyBlock?
    public var didPhotoUnfoldCompletedAction: EmptyBlock?
    
    public var panGestureBeginAction: ((_ translationY: CGFloat) -> Void)?
    
    public var isListenKeyboard: Bool = true
    
    public var isTop: Bool = false
    
    public var isSwiping: Bool = false
    
    public var originalY: CGFloat = 0.0
    
    public weak var aboveView: UIView?
    
    public var didClickedItemButtonAction: ((_ sender: AttachedButton<Type>) -> Void)?
    
    public var updatingTopAction: ((_ isShow: Bool, _ isCallFromKeyboard: Bool, _ isClickBlockCall: Bool) -> Void)?
    
    public var swipeBeginAction: EmptyBlock?
    
    public var swipeChangedAction: ((_ progress: CGFloat) -> Void)?
    
    public var callInputViewWakeupAction: EmptyBlock?

    public var items: [AttachedItem<Type>] = []
    
    public lazy var topView: UIView = {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: Appearance.screenW, height: 50.0))
        view.backgroundColor = self.appearance.bgColor
        return view
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: Appearance.screenW, height: 0.5))
        view.backgroundColor = self.appearance.lineColor
        return view
    }()
    
    private lazy var emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = self.appearance.bgColor
        return view
    }()
    
    private lazy var attachedButtons: [AttachedButton<Type>] = []
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    public weak var currentShowingAttachedView: AttachedView<Type>?
    
    private lazy var keyboardMan: KeyboardMan = KeyboardMan()
    
    public var keyboardDismissShouldSetTop: Bool = true
    
    private weak var bgActionControl: UIControl?
    
    private var isShowAttachedView: Bool = false
    
    private let appearance: AttachedAppearance

    init(attactedToolbarAppearance: AttachedAppearance = AttachedAppearance()) {
        self.appearance = attactedToolbarAppearance
        super.init(frame: .zero)
        self.backgroundColor = self.appearance.bgColor
    }
    
    public init(attactedToolbarAppearance: AttachedAppearance = AttachedAppearance(), frame: CGRect = .zero) {
        self.appearance = attactedToolbarAppearance
        super.init(frame: frame)
        self.backgroundColor = self.appearance.bgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard let superV = self.superview else {
            return
        }
        
        // 布局
        self.layoutViews(superV: superV)
        
        // 监听键盘
        if isListenKeyboard {
            self.listenKeyboard()
        }
        
        // 监听手势
        self.addGesture()
    }
    
    @objc func panGestureAction(_ sender: UIPanGestureRecognizer) {
        let translationY = sender.translation(in: self).y
        
        panGestureBeginAction?(translationY)
        
        if !self.isTop, !self.isSwiping, translationY > 0 {
            self.dissmiss(isWakeupInputView: false)
            return
        }
        
        guard self.currentShowingAttachedView?.canSwipeGuesture ?? false else {
            self.swipeChangedAction?(0.0)
            self.isSwiping = false
            return
        }

        switch sender.state {
        case .began:
            if !self.isTop {
                self.originalY = self.e_top
            }
            
            self.swipeBeginAction?()
        case .changed:
            self.isSwiping = true
            let y = self.isTop ? translationY : self.originalY + translationY
            self.e_top = y
            if y >= self.originalY {
                self.e_top = self.originalY
            } else if y <= Appearance.statusBarH {
                self.e_top = Appearance.statusBarH
            }
            self.currentShowingAttachedView?.e_top = self.e_bottom - Appearance.safeBottomHeight
            self.currentShowingAttachedView?.e_height = (self.superview?.e_height ?? 0.0) - (self.currentShowingAttachedView?.e_top ?? 0.0)
            let progress = 1.0 - (self.e_top / (self.originalY))
            self.swipeChangedAction?(progress)
        case .ended, .cancelled, .failed:
            self.isSwiping = false
            if (self.originalY - self.e_top) <= 100 {
                self.photoFoldCompletedAction()
            } else {
                self.photoUnfoldCompletedAction()
            }
        default:
            self.isSwiping = false
            self.originalY = 0.0
        }
    }
    
    @objc func bgActionControlAction() {
        self.dissmiss()
    }
    
    @objc func dissmiss(isWakeupInputView: Bool = true, isClickBlockCall: Bool = false) {
        self.superview?.endEditing(true)
        if isWakeupInputView {
            self.hideAttachedView(isSetTop: false, isClickBlockCall: isClickBlockCall)
            self.callInputViewWakeupAction?()
        } else {
            self.hideAttachedView(isClickBlockCall: isClickBlockCall)
        }
        self.attachedButtons.forEach {
            $0.isSelected = false
        }
    }
    
    @objc func itemButtonAction(_ sender: UIButton) {
        guard let sender = sender as? AttachedButton<Type> else { return }
        self.didClickedItemButtonAction?(sender)
        if let clickBlock = self.items.filter({ $0.button == sender }).first?.clickBlock {
            self.dissmiss(isWakeupInputView: false, isClickBlockCall: true)
            clickBlock?()
        } else {
            if let returnBlock = self.items.filter({ $0.button == sender }).first?.returnBlock {
                if returnBlock() {
                    return
                }
            }
            sender.isSelected = !sender.isSelected
            self.attachedButtons.forEach {
                if $0 != sender {
                    $0.isSelected = false
                }
            }
            if sender.isSelected {
                self.keyboardDismissShouldSetTop = false
                CATransaction.begin()
                self.superview?.endEditing(true)
                CATransaction.setCompletionBlock {
                    self.keyboardDismissShouldSetTop = true
                }
                CATransaction.commit()
                self.showAttachedView(type: sender.type)
            } else {
                self.hideAttachedView(isSetTop: !self.appearance.isSwitchKeyboardInput)
                if self.appearance.isSwitchKeyboardInput {
                    self.callInputViewWakeupAction?()
                }
            }
        }
    }
}

// MARK: - Public

extension KeyboardAttachedToolbar {
    
    /// 添加键盘监听
    public func addKeyboardListen() {
        self.keyboardMan.keyboardObserveEnabled = true
    }
    
    /// 移除键盘监听
    public func removeKeyboardListen() {
        self.keyboardMan.keyboardObserveEnabled = false
    }
    
    public func setDisable(types: [Type]) {
        self.attachedButtons.forEach {
            if types.contains($0.type) {
                $0.isEnabled = false
            }
        }
    }
    
    public func setEnable(types: [Type]) {
        self.attachedButtons.forEach {
            if types.contains($0.type) {
                $0.isEnabled = true
            }
        }
    }
    
    public func wakeupKeyboard() {
        self.dissmiss(isWakeupInputView: true)
    }
    
    public func dismissAttachedView() {
        self.dissmiss(isWakeupInputView: false)
    }
    
    public func resetItemButtons() {
        self.items.forEach { $0.button.isSelected = false }
    }
}

// MARK: - Private

private extension KeyboardAttachedToolbar {
    
    func layoutViews(superV: UIView) {
        let height: CGFloat = self.topView.e_height + Appearance.safeBottomHeight
        self.frame = CGRect(x: 0.0, y: superV.e_height - height, width: superV.e_width, height: height)
        
        if !self.subviews.contains(self.topView) {
            self.addSubview(self.topView)
        }
        
        if !self.topView.subviews.contains(self.lineView), self.appearance.isShowLine {
            self.topView.addSubview(self.lineView)
        }
        
        if !self.topView.subviews.contains(buttonsStackView) {
            self.topView.addSubview(self.buttonsStackView)
            
            self.buttonsStackView.snp.makeConstraints { make in
                make.leading.equalTo(appearance.spacing)
                make.centerY.equalToSuperview().offset(appearance.verticalSpacing)
            }
        }
        
        if self.emptyView.superview == nil {
            emptyView.frame = CGRect(x: 0.0, y: self.e_top, width: superV.e_width, height: superV.e_height - self.e_top)
            superV.insertSubview(emptyView, belowSubview: self)
        }
        
        if attachedButtons.isEmpty {
            for item in items {
                item.button.addTarget(self, action: #selector(itemButtonAction(_:)), for: .touchUpInside)
                self.buttonsStackView.addArrangedSubview(item.button)
                let width = self.appearance.isFullToolbarAttached ? (self.e_width - appearance.spacing * 2.0) / CGFloat(items.count) : appearance.itemWidth
                item.button.snp.makeConstraints { make in
                    make.size.equalTo(
                        CGSize(width: width, height: self.topView.e_height))
                }
                self.attachedButtons.append(item.button)
            }
        }
    }
    
    func addAttachedView(item: AttachedItem<Type>, canSwipeGuesture: Bool) -> AttachedView<Type>? {
        guard let superV = self.superview else { return nil }
        if let customView = item.customView, !superV.subviews.contains(customView) {
            let view = AttachedView(type: item.button.type, canSwipeGuesture: canSwipeGuesture, showView: customView)
            view.frame = CGRect(x: 0.0, y: superV.e_height - customView.e_height, width: customView.e_width, height: customView.e_height)
            view.transform = CGAffineTransform(translationX: 0.0, y: view.e_height)
            view.alpha = 0.0
            superV.addSubview(view)
            return view
        } else {
            return nil
        }
    }
    
    func listenKeyboard() {
        keyboardMan.animateWhenKeyboardAppear = { [weak self] appearPostIndex, keyboardHeight, keyboardHeightIncrement in
            guard let sSelf = self, let superV = sSelf.superview else { return }
            sSelf.hideAttachedView()
            sSelf.currentShowingAttachedView = nil
            if sSelf.keyboardDismissShouldSetTop {
                sSelf.updateY(superV.e_height - keyboardHeight - sSelf.topView.e_height, isCallFromKeyboard: true)
            }
        }
        keyboardMan.animateWhenKeyboardDisappear = { [weak self] keyboardHeight in
            guard let sSelf = self, let superV = sSelf.superview else { return }
            sSelf.hideAttachedView()
            sSelf.currentShowingAttachedView = nil
            if sSelf.keyboardDismissShouldSetTop {
                sSelf.updateY(superV.e_height - sSelf.e_height, isCallFromKeyboard: true)
            }
        }
    }
    
    func updateY(_ value: CGFloat, isCallFromKeyboard: Bool = false, isClickBlockCall: Bool = false) {
        self.e_top = value
        if let superV = self.superview {
            self.emptyView.e_top = self.e_top
            self.emptyView.e_height = superV.e_height - self.e_top
        }
        self.updatingTopAction?(self.isShowAttachedView, isCallFromKeyboard, isClickBlockCall)
    }
    
    func addGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        pan.maximumNumberOfTouches = 1
        self.addGestureRecognizer(pan)
    }
    
    func showAttachedView(type: Type) {
        guard let item = self.items.first(where: { i in
            return i.button.type == type
        }) else { return }
        self.isShowAttachedView = true
        let prevView = self.currentShowingAttachedView
        self.currentShowingAttachedView = self.addAttachedView(item: item, canSwipeGuesture: item.button.canSwipeGuesture)
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear, animations: {
            if let prevView = prevView{
                prevView.alpha = 0.0
                prevView.transform = CGAffineTransform(translationX: 0.0, y: prevView.e_height)
            }
            self.currentShowingAttachedView?.alpha = 1.0
            self.currentShowingAttachedView?.transform = .identity
            self.updateY((self.currentShowingAttachedView?.e_top ?? 0.0) - self.topView.e_height)
        }, completion: { isFinished in
            guard isFinished else { return }
            prevView?.removeFromSuperview()
            if self.bgActionControl == nil, self.appearance.isSwitchKeyboardInput {
                let bgActionControl = UIControl()
                bgActionControl.addTarget(self, action: #selector(self.bgActionControlAction), for: .touchUpInside)
                bgActionControl.frame = CGRect(x: 0.0, y: 0.0, width: self.e_width, height: self.e_top)
                if let aboveView = self.aboveView {
                    self.superview?.insertSubview(bgActionControl, belowSubview: aboveView)
                } else {
                    self.superview?.insertSubview(bgActionControl, belowSubview: self)
                }
                self.bgActionControl = bgActionControl
            }
        })
    }
    
    func hideAttachedView(isSetTop: Bool = true, isClickBlockCall: Bool = false) {
        if isClickBlockCall {
            self.isShowAttachedView = false
            let view = self.currentShowingAttachedView
            self.currentShowingAttachedView?.removeFromSuperview()
            self.currentShowingAttachedView = nil
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear, animations: {
                if let v = view {
                    v.alpha = 0.0
                    v.transform = CGAffineTransform(translationX: 0.0, y: v.e_height)
                }
                if isSetTop {
                    self.updateY((self.superview?.e_height ?? 0.0) - self.e_height, isClickBlockCall: true)
                }
            }, completion: { _ in
                self.bgActionControl?.removeFromSuperview()
            })
            return
        }
        guard let view = self.currentShowingAttachedView else { return }
        self.currentShowingAttachedView = nil
        self.isShowAttachedView = false
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear, animations: {
            view.alpha = 0.0
            view.transform = CGAffineTransform(translationX: 0.0, y: view.e_height)
            if isSetTop {
                self.updateY((self.superview?.e_height ?? 0.0) - self.e_height)
            }
        }, completion: { _ in
            view.removeFromSuperview()
            self.bgActionControl?.removeFromSuperview()
        })
    }
}

// MARK: - Action

public extension KeyboardAttachedToolbar {
    
    func photoFoldCompletedAction() {
        let destinationY: CGFloat = self.originalY
        let currentShowingAttachedViewY: CGFloat = destinationY + (self.e_height - Appearance.safeBottomHeight)
        let currentShowingAttachedViewH: CGFloat = (self.superview?.e_height ?? 0.0) - currentShowingAttachedViewY
        
        UIView.animate(withDuration: 0.2, animations: {
            self.e_top = destinationY
            self.currentShowingAttachedView?.e_top = currentShowingAttachedViewY
            self.currentShowingAttachedView?.e_height = currentShowingAttachedViewH
            self.didPhotoFoldCompletedAction?()
        }, completion: { _ in
            self.currentShowingAttachedView?.e_height = currentShowingAttachedViewH
            self.swipeChangedAction?(0.0)
        })
        self.isTop = false
    }
    
    func photoUnfoldCompletedAction() {
        let destinationY: CGFloat = Appearance.statusBarH
        let currentShowingAttachedViewY: CGFloat = destinationY + (self.e_height - Appearance.safeBottomHeight)
        let currentShowingAttachedViewH: CGFloat = (self.superview?.e_height ?? 0.0) - currentShowingAttachedViewY
        
        UIView.animate(withDuration: 0.2, animations: {
            self.e_top = destinationY
            self.currentShowingAttachedView?.e_top = currentShowingAttachedViewY
            self.currentShowingAttachedView?.e_height = currentShowingAttachedViewH
            self.didPhotoUnfoldCompletedAction?()
        }, completion: { _ in
            self.swipeChangedAction?(1.0)
        })
        self.isTop = true
    }
}
