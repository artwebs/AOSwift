//
//  UIAODialog.swift
//  HongyuanProperty
//
//  Created by 刘洪彬 on 2019/2/17.
//  Copyright © 2019 liu hongbin. All rights reserved.
//

import UIKit
import AOCocoa


protocol UIAODialogDelegate{
    func dialog(dialog:UIAODialog,result:[String:Any])
}

class UIAODialog: UIView {
    var delegate:UIAODialogDelegate?
    var width:CGFloat = 0
    var height:CGFloat = 0
    var value:[String:Any]{
        get{
            return [:]
        }
    }
    var callback:(([String:Any])->Void)?
    
    private var _listener = UIListener()
    override  var listener : UIListener{
        get{
            return _listener
        }
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     */
    init(frame: CGRect ,width:CGFloat,height:CGFloat) {
        super.init(frame: frame)
        self.width = width
        self.height = height
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func drawFromView(view:UIView){
        
        
    }
    
    override func draw(_ rect: CGRect) {
        let alertView = UIView(frame: rect)
        alertView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.width = self.width > rect.width-20 ? rect.width-20:self.width
        self.height = self.height > rect.height-80 ? rect.height-20:self.height
        let container = UIView(frame: CGRect(x: 10, y: 40, width: self.width, height: self.height))
        container.layer.cornerRadius = 10
        container.layer.masksToBounds = true
        container.backgroundColor = UIColor.white
        container.center = CGPoint(x: rect.width*0.5, y: rect.height*0.5)
        
        let btnWidth = (container.bounds.width-60)*0.5
        let submitBtn = UIButton(frame: CGRect(x: 24, y: container.bounds.height-60, width: btnWidth, height: 36))
        submitBtn.setTitle("选择", for: .normal)
        submitBtn.layer.cornerRadius = 6.0
        submitBtn.layer.masksToBounds = true
        submitBtn.setTitleColor(UIColor.white, for: .normal)
        submitBtn.setBackgroundImage(Utils.createImage(with: AppDefault.DefaultBlue), for: .normal)
        self.click(submitBtn) {
            self.delegate?.dialog(dialog: self, result:self.value)
            self.callback?(self.value)
            self.removeFromSuperview()
        }
        container.addSubview(submitBtn)
        
        let canceBtn = UIButton(frame: CGRect(x: btnWidth+36, y: container.bounds.height-60, width: btnWidth, height: 36))
        canceBtn.setTitle("取消", for: .normal)
        canceBtn.layer.cornerRadius = 6.0
        canceBtn.layer.masksToBounds = true
        canceBtn.setTitleColor(UIColor.white, for: .normal)
        canceBtn.setBackgroundImage(Utils.createImage(with: AppDefault.DefaultBlue), for: .normal)
        self.click(canceBtn) {
            self.removeFromSuperview()
        }
        container.addSubview(canceBtn)
        
        let content = UIView(frame: CGRect(x: 20, y: 20, width: container.bounds.width-40, height: container.bounds.height-90))
//        content.backgroundColor = AppDefault.DefaultLightBlue
        container.addSubview(content)
        
        alertView.addSubview(container)
        self.addSubview(alertView)
        self.drawFromView(view: content)
        
    }
    
    
    

}
