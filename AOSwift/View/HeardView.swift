//
//  HeardView.swift
//  WebServer
//
//  Created by rsmac on 15/10/12.
//  Copyright © 2015年 artwebs. All rights reserved.
//

import UIKit

protocol HeardViewDelegate{
    func onClickLeftBtn();
    func onClickRightBtn();
}

class HeardView: UIView {
    var leftBtn : UIButton?
    var rightBtn : UIButton?
    var titleLabel : UILabel?
    var centerView : UIView?
    var viewController : UIViewController?
    var delegate : HeardViewDelegate?
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
//        self.backgroundColor = AppDefault.ColorBlue
        leftBtn = UIButton(frame: CGRectMake(10, 20, 40, 40))
        leftBtn?.center = CGPointMake((leftBtn?.center.x )!, (rect.height+20)*0.5)
        
        self.addSubview(leftBtn!)
        
        centerView  = UIView(frame: CGRectMake(0, 20, rect.width-100, 30))
        centerView?.center = CGPointMake(rect.width*0.5, (rect.height+20)*0.50)
        self.addSubview(centerView!)
        
        rightBtn = UIButton(frame: CGRectMake(rect.width-64, 20, 44, 44))
        rightBtn?.center = CGPointMake((rightBtn?.center.x )!, (rect.height+20)*0.5)
        self.addSubview(rightBtn!)
        
    }
    
    func initTitleLayout(title :String ){
        if let rect = centerView?.frame {
            titleLabel = UILabel(frame: CGRectMake(0, 0, rect.width, rect.height))
            titleLabel?.textColor = UIColor.whiteColor()
            titleLabel?.text = title
            titleLabel?.textAlignment = NSTextAlignment.Center
            titleLabel?.center = CGPointMake(rect.width*0.5, rect.height*0.50)
            centerView?.addSubview(titleLabel!)
        }
        
    }
    
    
    func initImageBtnLayout(){
        
    }
    
    func initOtherLayout(view : UIView){
        
    }
    
    func initDefault(){
//        leftBtn?.setImage(UIImage(named: "ico_in"), forState: UIControlState.Normal)
        titleLabel?.text = "Web Server"
        
    }
    
    func setBack(controller : UIViewController){
        viewController = controller
        leftBtn?.setTag(1000);
//        leftBtn?.setImage(UIImage(named: "ico_back"), forState: UIControlState.Normal)
        leftBtn?.addTarget(self, action: "onClick:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func setSetting(controller :  UIViewController){
        viewController = controller
//        rightBtn?.setImage(UIImage(named: "ico_setting"), forState: UIControlState.Normal);
        rightBtn?.setTag(1001)
        rightBtn?.addTarget(self, action: "onClick:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    
    func onClick(sender : UIButton){
        switch(sender.tag()){
        case 1000:
            delegate?.onClickLeftBtn()
//            viewController?.navigationController?.popToRootViewControllerAnimated(true)
            break;
        case 1001:
            delegate?.onClickRightBtn()
//          viewController?.navigationController?.pushViewController((viewController?.storyboard?.instantiateViewControllerWithIdentifier(SettingViewController.identifier))!, animated: true)
            break;
        default:
            break;
        }
    }

}
