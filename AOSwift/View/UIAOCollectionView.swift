//
//  UIAOVollectionView.swift
//  RakubaiIOS
//
//  Created by 刘洪彬 on 2019/11/18.
//  Copyright © 2019 liu hongbin. All rights reserved.
//

import UIKit

@objc protocol UIAOCollectionViewDelegate {
    func collectionView(_ collectionView:UIAOCollectionView,page:Int,pageSize:Int)
    @objc optional func collectionViewForCellHeight(_ collectionView:UIAOCollectionView,index:IndexPath)->CGFloat
    func collectionView(_ collectionView:UIAOCollectionView,cell:UIAOCollectionViewCell,index:IndexPath,row:[String:AnyObject])
    @objc optional func collectionViewDidClick(_ collectionView:UIAOCollectionView,index:IndexPath,row:[String:AnyObject])
}

class UIAOCollectionView: UIAOView,UICollectionViewDelegate,UICollectionViewDataSource {
    var collectionView :UICollectionView?
    var rows:[[String:AnyObject]] = []
    var delegate:UIAOCollectionViewDelegate?
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

    override func draw(_ rect: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical;
        let itemWidth = (rect.width-8)/2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth+70);
        layout.minimumInteritemSpacing = 4
        print(rect.width,rect.height)
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: rect.width, height: rect.height), collectionViewLayout: layout)
        self.collectionView?.register(GoodsCollectionViewCell.self, forCellWithReuseIdentifier: "CellID")
        self.collectionView?.backgroundColor = UIColor.clear
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.addSubview(self.collectionView!)
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
    
    func reload() {
        self.delegate?.collectionView(self, page: page, pageSize: pageSize)
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    func loadMore() {
        if more == .loading || more == .finish{
            return
        }
        more = .loading
        self.page = self.page + 1
        self.delegate?.collectionView(self, page: page, pageSize: pageSize)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.rows.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath) as! GoodsCollectionViewCell
        cell.reload(param: self.rows[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        self.delegate?.collectionViewDidClick?(self, index: indexPath, row: self.rows[indexPath.row]);
        return true
    }

}

class UIAOCollectionViewCell:UICollectionViewCell{
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
    
}
