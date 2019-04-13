//
//  ListView.swift
//  HongyuanProperty
//
//  Created by 刘洪彬 on 2019/1/19.
//  Copyright © 2019 liu hongbin. All rights reserved.
//

import UIKit

@objc protocol UIAOListViewDelegate {
    func listView(listView:UIAOListView,page:Int,pageSize:Int)
    @objc optional func listViewForCellHeight(listView:UIAOListView,index:IndexPath)->CGFloat
    func listView(listView:UIAOListView,cell:UIAOListViewCell,index:IndexPath,row:[String:AnyObject])
    @objc optional func listViewDidClick(listView:UIAOListView,index:IndexPath,row:[String:AnyObject])
}

class UIAOListView: UIView,UITableViewDataSource,UITableViewDelegate {
    let listView = UITableView()
    var rows:[[String:AnyObject]] = []
    var listViewDelegate:UIAOListViewDelegate?
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
        listView.tableFooterView = UIView()
        self.addSubview(listView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return self.listViewDelegate?.listViewForCellHeight?(listView: self, index: indexPath) ?? CGFloat(88)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: UIAOListView.className) as? UIAOListViewCell
        if cell == nil{
            cell = UIAOListViewCell(style: .default, reuseIdentifier: UIAOListView.className)
        }
        
        self.listViewDelegate?.listView(listView: self, cell: cell!,index:indexPath,row: self.rows[indexPath.row])
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.listViewDelegate?.listViewDidClick?(listView: self, index: indexPath, row: self.rows[indexPath.row])
    }
    
    func setData(data:[[String:AnyObject]]?){
        print(data)
        self.rows.removeAll()
        if let val = data{
            for item in val{
                self.rows.append(item)
            }
        }
    }
    

}

class UIAOListViewCell: UITableViewCell {
    var views:[String:UIView] = [:]
    private var _listener = UIListener()
    override  var listener : UIListener{
        get{
            return _listener
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
