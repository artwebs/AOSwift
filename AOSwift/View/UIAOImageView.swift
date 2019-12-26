//
//  UIAOImageView.swift
//  Yixiang
//
//  Created by 刘洪彬 on 2019/12/24.
//  Copyright © 2019 artwebs. All rights reserved.
//

import UIKit

class UIAOImageView:UIImageView,UIAOFormControl {
    private var _vaild:UIAOFormVaild?
    private var _value:String?
    var vaild:UIAOFormVaild?{
       set{ self._vaild = newValue}
       get{ return self._vaild}
    }
    private var _field = ""
    var field: String{
       set{ self._field = newValue}
       get{ return self._field}
       
    }

    private var _finish:((UIAOFormControl)->Void)?
    var finish:((UIAOFormControl)->Void)?{
       set{ self._finish = newValue}
       get{ return self._finish}
       
    }
    var views = Dictionary<String,UIView>()
    private var _listener = UIListener()
    override  var listener : UIListener{
      get{
          return _listener
      }
    }

    var value:Any{
       set{
           if let opt = convert{
                self._value = opt(newValue)
           }else if let val = newValue as? Int{
                self._value = "\(val)"
           }else if let val = newValue as? Double{
                self._value = "\(val)"
           }else{
               self._value = newValue as? String
           }
       }
       get{ return self._value ?? "" }
    }

    var convert:((Any)->String)?

}
