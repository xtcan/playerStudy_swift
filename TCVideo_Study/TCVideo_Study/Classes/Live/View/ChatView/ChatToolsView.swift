//
//  ChatToolsView.swift
//  TCVideo_Study
//
//  Created by tcan on 2017/7/18.
//  Copyright © 2017年 tcan. All rights reserved.
//

import UIKit

protocol ChatToolsViewDelegate : class {
    func chatToolsView(toolView : ChatToolsView, message : String)
}

class ChatToolsView: UIView ,NibLoadable{

    /// 代理属性
    weak var delegate : ChatToolsViewDelegate?
    fileprivate lazy var emotionBtn : UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
    fileprivate lazy var emotionView : EmotionView = EmotionView(frame : CGRect(x: 0, y: 0, width: kScreenW, height: 250))
    /// 文字输入框
    @IBOutlet weak var inputTextField: UITextField!
    /// 发送按钮
    @IBOutlet weak var sendMsgBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }

    /// 输入文字
    @IBAction func textFieldDidEdit(_ sender: UITextField) {
        sendMsgBtn.isEnabled = sender.text!.characters.count != 0
    }
    
    /// 发送按钮点击
    @IBAction func sendBtnClick(_ sender: UIButton) {
        //获取输入到内容
        let message = inputTextField.text!
        //清空内容
        inputTextField.text = ""
        sender.isEnabled = false
        
        //把输入的内容传递给代理
        delegate?.chatToolsView(toolView: self, message: message)
    }
    
}

extension ChatToolsView {
    
    fileprivate func setupUI(){
        
        //测试: 让textFiled显示`富文本`
//         let attrString = NSAttributedString(string: "I am fine", attributes: [NSForegroundColorAttributeName : UIColor.green])
//         let attachment = NSTextAttachment()
//         attachment.image = UIImage(named: "[大哭]")
//         let attrStr = NSAttributedString(attachment: attachment)
//         inputTextField.attributedText = attrStr
 
        
        // 1.初始化inputView中rightView
        emotionBtn.setImage(UIImage(named: "chat_btn_emoji"), for: .normal)
        emotionBtn.setImage(UIImage(named: "chat_btn_keyboard"), for: .selected)
        emotionBtn.addTarget(self, action: #selector(emotionBtnClick(_:)), for: UIControlEvents.touchUpInside)
        
        inputTextField.rightView = emotionBtn
        inputTextField.rightViewMode = .always
        inputTextField.allowsEditingTextAttributes = true
        
        // 2.设置emotionView的闭包(weak当对象销毁值, 会自动将指针指向nil)
//        weak var weakSelf = self
        emotionView.emotionClickCallback = {[weak self] emotion in
            // 1.判断是否是删除按钮
            if emotion.emotionName == "delete-n" {
                self?.inputTextField.deleteBackward()
                return
            }
            
            // 2.获取光标位置
            guard let range = self?.inputTextField.selectedTextRange else { return }
            self?.inputTextField.replace(range, withText: emotion.emotionName)
        }
    }
}

extension ChatToolsView {
    
    @objc fileprivate func emotionBtnClick(_ btn : UIButton){
        
        btn.isSelected = !btn.isSelected
        
        //切换键盘
        //记录当前光标的位置
        let range = inputTextField.selectedTextRange
        inputTextField.resignFirstResponder()
        inputTextField.inputView = inputTextField.inputView == nil ? emotionView : nil
        inputTextField.becomeFirstResponder()
        //恢复光标的位置
        inputTextField.selectedTextRange = range
    }
}
