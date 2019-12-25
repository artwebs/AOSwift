//
//  UITextFieldExtension.swift
//  HongMengPF
//
//  Created by 刘洪彬 on 2019/11/16.
//  Copyright © 2019 artwebs. All rights reserved.
//

import UIKit

extension UITextField{
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar = UIToolbar()
        //左侧的空隙
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,target: nil, action: nil)
        
        //右侧的完成按钮
        let done: UIBarButtonItem = UIBarButtonItem(title: "完成", style: .done,target: self,action: #selector(doneButtonAction))
        var items:[UIBarButtonItem] = []
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
    
    func addKeyboardLayout(parent:UIView){
        //键盘弹出监听，解决键盘挡住输入框的问题
        Layout(parent:parent)
        class Layout{
            //记录 self.view 的原始 origin.y
            private var originY: CGFloat = 0
            //正在输入的UITextField
            private var editingText: UITextField?
            private var view:UIView!

            init(parent:UIView) {
                self.view = parent
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
            }
            //键盘弹起
            @objc func keyboardWillAppear(notification: NSNotification) {
                // 获得软键盘的高
                let keyboardinfo = notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey]
                let keyboardheight:CGFloat = (keyboardinfo as AnyObject).cgRectValue.size.height
                
                //计算输入框和软键盘的高度差
                self.originY = self.view.frame.origin.y
                let rect = self.editingText!.convert(self.editingText!.bounds, to: self.view)
                let y = self.view.bounds.height - rect.origin.y - self.editingText!.bounds.height - keyboardheight
                
                //设置中心点偏移
                UIView.animate(withDuration: 0.5) {
                    if y < 0 {
                        self.view.frame.origin.y = (self.originY + y)
                    }
                }
            }
            
            //键盘落下
            @objc func keyboardWillDisappear(notification:NSNotification){
                //软键盘收起的时候恢复原始偏移
                UIView.animate(withDuration: 0.5) {
                    self.view.frame.origin.y = self.originY
                }
            }
        }
    }
    
    
}
