//
//  ViewController.swift
//  KeyboardAttachedToolbar
//
//  Created by Konoke on 05/07/2021.
//  Copyright (c) 2021 Konoke. All rights reserved.
//

import UIKit

enum KeyboardAttachedCustomType {
    case photo
    case audio
    case vote
    case gift
    case emoji
}

class ViewController: UIViewController {

    @IBOutlet private weak var textView: UITextView!
    
    private lazy var appearacne: AttachedAppearance = {
        var appearance = AttachedAppearance()
        appearance.isFullToolbarAttached = true
        appearance.isSwitchKeyboardInput = true
        return appearance
    }()
    
    private lazy var attachedView: KeyboardAttachedToolbar<KeyboardAttachedCustomType> = {
        let attachedView = KeyboardAttachedToolbar<KeyboardAttachedCustomType>(attactedToolbarAppearance: appearacne)
        return attachedView
    }()
    
    // 图片选择
    private lazy var photoView: UIView = {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: Appearance.screenW, height: 400.0))
        view.backgroundColor = .green
        return view
    }()
    
    // 音频选择
    private lazy var audioView: UIView = {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: Appearance.screenW, height: 400.0))
        view.backgroundColor = .red
        return view
    }()
    
    // 投票选择
    private lazy var voteView: UIView = {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: Appearance.screenW, height: 400.0))
        view.backgroundColor = .orange
        return view
    }()
    
    // emoji选择
    private lazy var emojiView: UIView = {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: Appearance.screenW, height: 400.0))
        view.backgroundColor = .yellow
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attachedView.items = [
            // 图片
            AttachedItem<KeyboardAttachedCustomType>(button: AttachedButton(type: .photo, icon: UIImage(named: "moment_photo"), iconHighlighted: UIImage(named: "moment_keyboard"), iconDisabled: UIImage(named: "moment_photo_disabled")), customView: photoView),
            
            // 音频
            AttachedItem<KeyboardAttachedCustomType>(button: AttachedButton(type: .audio, icon: UIImage(named: "moment_mic"), iconHighlighted: UIImage(named: "moment_micHighlight"), iconDisabled: UIImage(named: "moment_mic_disabled")), customView: audioView),
            
            // 投票选择
            AttachedItem<KeyboardAttachedCustomType>(button: AttachedButton(type: .vote, icon: UIImage(named: "moment_vote"), iconHighlighted: UIImage(named: "moment_voteHighlight")), customView: voteView),
            
            // emoji
            AttachedItem<KeyboardAttachedCustomType>(button: AttachedButton(type: .emoji, icon: UIImage(named: "moment_emojiHighlight")), customView: emojiView),
            
            // gift按钮(不弹出view)
            AttachedItem<KeyboardAttachedCustomType>(button: AttachedButton(type: .gift, icon: UIImage(named: "moment_tool_gift")), customView: voteView, clickBlock: {
                print("点击了礼物")
            })
        ]
        
        attachedView.callInputViewWakeupAction = { [weak self] in
            self?.textView.becomeFirstResponder()
        }
        
        self.view.addSubview(attachedView)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

