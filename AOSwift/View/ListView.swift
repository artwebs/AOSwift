//
//  ListView.swift
//  HongyuanProperty
//
//  Created by 刘洪彬 on 2019/1/19.
//  Copyright © 2019 liu hongbin. All rights reserved.
//

import UIKit

@objc protocol ListViewDelegate {
    func listView(listView:ListView,page:Int,pageSize:Int)
    @objc optional func listViewForCellHeight(listView:ListView,index:IndexPath)->CGFloat
    func listView(listView:ListView,cell:ListViewCell,index:IndexPath,row:[String:AnyObject])
}

class ListView: UIView,UITableViewDataSource,UITableViewDelegate {
    let listView = UITableView()
    var rows:[[String:AnyObject]] = []
    var listViewDelegate:ListViewDelegate?
    var page = 1
    var pageSize = 10
    
    func reload() {
        self.listViewDelegate?.listView(listView: self, page: page, pageSize: pageSize)
       
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.listView.reloadData()
        }
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     
     */
    override func draw(_ rect: CGRect) {
        // Drawing code
        listView.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
        listView.dataSource = self
        listView.delegate = self
        self.addSubview(listView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return self.listViewDelegate?.listViewForCellHeight?(listView: self, index: indexPath) ?? CGFloat(88)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: ListView.className) as? ListViewCell
        if cell == nil{
            cell = ListViewCell(style: .default, reuseIdentifier: ListView.className)
        }
        
        self.listViewDelegate?.listView(listView: self, cell: cell!,index:indexPath,row: self.rows[indexPath.row])
        return cell!
    }
    
    func setData(data:[[String:AnyObject]]?){
        self.rows.removeAll()
        if let val = data{
            for item in val{
                self.rows.append(item)
            }
        }
    }
    

}
