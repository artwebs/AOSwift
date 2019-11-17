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
    var noticeView:UILabel?
    var total:Int?
    var moreView:UIView{
        get{
            let view = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 44))
            view.text = more.rawValue
            view.textAlignment = .center
            view.textColor = UIColor.lightGray
            view.font = UIFont.systemFont(ofSize: 12)
            return view
        }
    }
    
    enum MoreState:String {
        case normal = "加载更多数据"
        case loading = "正在加载数据"
        case finish = "没有更多数据"
    }
    var more = MoreState.normal
    
    func reload() {
        self.listViewDelegate?.listView(listView: self, page: page, pageSize: pageSize)
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.listView.reloadData()
        }
    }
    
    func loadMore() {
        if more == .loading || more == .finish{
            return
        }
        more = .loading
        listView.tableFooterView = nil
        self.page = self.page + 1
        self.listViewDelegate?.listView(listView: self, page: page, pageSize: pageSize)
        
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        listView.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
        listView.dataSource = self
        listView.delegate = self
        listView.tableFooterView = UIView()
        self.addSubview(listView)
        
        noticeView = UILabel(frame: CGRect(x: 0, y: 0, width: rect.width, height: 44))
        noticeView?.center = CGPoint(x:rect.width*0.5,y:rect.height*0.5)
        noticeView?.text = "没有更多数据"
        noticeView?.textColor = UIColor.lightGray
        noticeView?.textAlignment = .center
        listView.addSubview(noticeView!)
        self.noticeView?.isHidden = true
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
        for item in cell!.builds{
            item(self.rows[indexPath.row])
        }
        if indexPath.row == self.rows.count - 1{
            tableView.tableFooterView = moreView
            loadMore()
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.listViewDelegate?.listViewDidClick?(listView: self, index: indexPath, row: self.rows[indexPath.row])
    }
    
    func setData(data:[[String:AnyObject]]?){
//        print(data) 
//        self.rows.removeAll()
        if data?.count == 0{
            more = .finish
            return
        }
        
        
        if let val = data{
            for item in val{
                self.rows.append(item)
            }
        }
        if let t = self.total{
            if t<=self.rows.count{
                more = .finish
            }
        }else{
            more = .normal
        }
        DispatchQueue.main.async {
            if self.rows.count>0{
                self.noticeView?.isHidden = true
            }else{
                self.noticeView?.isHidden = false
            }
        }
    }
    
    

}

class UIAOListViewCell: UITableViewCell {
    var views:[String:UIView] = [:]
    var builds:[([String:AnyObject])->Void] = []
    private var _listener = UIListener()
    override  var listener : UIListener{
        get{
            return _listener
        }
    }
    
    func build(act:@escaping ([String:AnyObject])->Void)  {
        builds.append(act)
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
