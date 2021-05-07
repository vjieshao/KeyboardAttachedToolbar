# KeyboardAttachedToolbar



## 简介

一个快速集成keyobard附属view的控件，可以多个tag切换。



## 效果

<img src="./demo.gif" alt="demo" style="width:200px"/>



## 导入

```
pod 'KeyboardAttachedToolbar'
```



## 依赖

s.dependency "KeyboardMan"

s.dependency "SnapKit"



## 使用

1. 初始化AttachedAppearance

    ```swift
    private lazy var appearacne: AttachedAppearance = {
        var appearance = AttachedAppearance()
        appearance.isFullToolbarAttached = true
        appearance.isSwitchKeyboardInput = true
        return appearance
    }()
    ```

    ```swift
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
    ```

2. 自定义枚举（按自己业务需求）

    ```swift
    enum KeyboardAttachedCustomType {
        case photo
        case audio
        case vote
        case gift
        case emoji
    }
    ```

3. 初始化KeyboardAttachedToolbar（将自定义枚举和KeyboardAttachedToolbar关联）

    ```swift
    private lazy var attachedView: KeyboardAttachedToolbar<KeyboardAttachedCustomType> = {
        let attachedView = KeyboardAttachedToolbar<KeyboardAttachedCustomType>(attactedToolbarAppearance: appearacne)
        return attachedView
    }()
    ```

4. 初始化各种需要弹出的view

    ```swift
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
    ```

5. 设置items

    ```swift
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
    ```



## Demo

demo在Example目录下，如有不懂，可以看demo。



## License

KeyboardAttachedToolbar is released under the MIT license. See [LICENSE](https://github.com/vjieshao/KeyboardAttachedToolbar/blob/master/LICENSE) for details.