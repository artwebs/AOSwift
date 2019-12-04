//
//  UIToolsView.swift
//  RakubaiIOS
//
//  Created by 刘洪彬 on 2019/10/11.
//  Copyright © 2019 liu hongbin. All rights reserved.
//

import UIKit
import AOCocoa

class UIAOToolsView: UIView {

    var _listener = UIListener()
    var lineWidth:CGFloat = 2
    var lineCount = 3
    var isShowTitle = true
    var imgZoom:CGFloat = 0.8
 
    override var listener: UIListener{
        get{
            return _listener
        }
    }
    var data:[UIAOToolsItem]!
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    func reload(title:String,items:[UIAOToolsItem]) {
        self.reload(title: title, allWidth: self.frame.width,items: items)
    }
    
    func reload(title:String,allWidth:CGFloat,items:[UIAOToolsItem]) {
        self.data = items
        self.backgroundColor = UIColor.white
        var allHeight:CGFloat = 4
        var viewHeight: CGFloat = 0
        if isShowTitle {
            viewHeight = 44
            let titleView = UILabel(frame: CGRect(x: 0, y: allHeight, width: allWidth, height: viewHeight))
            titleView.text = "   \(title)"
            titleView.backgroundColor = UIColor.white
            self.addSubview(titleView)
            
            allHeight += viewHeight
            viewHeight = lineWidth
        }
        
        let lineView = UIImageView(frame: CGRect(x: 0, y: allHeight, width: allWidth, height: viewHeight))
        lineView.image = Utils.createImage(with: AppDefault.DefaultLightGray)
        self.addSubview(lineView)
        allHeight+=viewHeight
        
        let cellWidth:CGFloat = allWidth/CGFloat(lineCount)
        var rowWidth:CGFloat = 0
        for i in 0..<items.count{
            if(i != 0 && i%lineCount==0){
                rowWidth=0
                allHeight+=viewHeight
                viewHeight = lineWidth
                let lineView = UIImageView(frame: CGRect(x: 0, y: allHeight, width: allWidth, height: viewHeight))
                lineView.image = Utils.createImage(with: AppDefault.DefaultLightGray)
                self.addSubview(lineView)
                allHeight+=viewHeight
            }
            
            viewHeight = 88
            let sideLength = cellWidth>viewHeight ? viewHeight * imgZoom : cellWidth * imgZoom
            let button = UIButton(frame: CGRect(x: rowWidth, y: allHeight, width: cellWidth, height: 88))
            let ico = UIImageView(frame: CGRect(x: 0, y: 0, width: sideLength, height:sideLength))
            if items[i].ico.hasPrefix("http"){
                ico.image = Utils.loadImageCache(withUrl: items[i].ico, defaultImage: "AppIcon")
            }else if(items[i].ico.hasPrefix("res:")){
                ico.image = UIImage(named:items[i].ico.replacingOccurrences(of: "res:", with: ""))?.toGrayImage()
            }else{
                ico.image = UIImage(named: items[i].ico)
            }
            
            ico.center = CGPoint(x: cellWidth*0.5, y: sideLength*0.5+15)
            button.addSubview(ico)
            let label = UILabel(frame: CGRect(x: 0, y: sideLength, width: cellWidth, height: sideLength))
            label.center = CGPoint(x: cellWidth*0.5, y: sideLength+30)
            label.text = items[i].title
            label.textAlignment = .center
            label.textColor = AppDefault.DefaultGray
            label.font = UIFont.systemFont(ofSize: 14)
            button.addSubview(label)
            self.click(button, listener: items[i].action)
            
            self.addSubview(button)
            rowWidth+=cellWidth
            
        }
    }

}

class UIAOToolsItem{
    var name:String
    var title:String
    var ico:String
    var action:()->Void
    
    init(name:String,title:String,ico:String,action:@escaping ()->Void){
        self.name = name
        self.title = title
        self.ico = ico
        self.action = action
    }
}
