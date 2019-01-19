//
//  ListViewRefresh.swift
//  HongyuanProperty
//
//  Created by 刘洪彬 on 2019/1/19.
//  Copyright © 2019 liu hongbin. All rights reserved.
//

import UIKit

class ListViewRefresh: ListView {
    fileprivate var refreshOperate :(_ page :Int ,_ pageSize :Int)->() = {page,pageSize in }
    fileprivate var moreOperate:(_ page :Int ,_ pageSize :Int)->() = {page,pageSize in }
    
    func setRefreshOperate(_ opt : @escaping (_ page :Int ,_ pageSize :Int)->()){
        self.refreshOperate=opt
    }
    
    func setMoreOperate(_ opt : @escaping (_ page :Int ,_ pageSize :Int)->()){
        self.moreOperate=opt
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
//        let options = PullToRefreshOption()
//        options.backgroundColor = UIColor.white
//        self.addPullToRefresh(options, refreshCompletion: { [weak self] in
//            // some code
//            self?.page=1
//            self?.refreshOperate(self!.page,self!.pageSize)
//        })
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
