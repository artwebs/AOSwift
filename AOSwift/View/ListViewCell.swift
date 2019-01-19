//
//  ListViewCell.swift
//  HongyuanProperty
//
//  Created by 刘洪彬 on 2019/1/19.
//  Copyright © 2019 liu hongbin. All rights reserved.
//

import UIKit

class ListViewCell: UITableViewCell {
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
