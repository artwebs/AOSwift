//
//  UIAOImageEdit.swift
//  Yixiang
//
//  Created by 刘洪彬 on 2019/12/9.
//  Copyright © 2019 artwebs. All rights reserved.
//

import UIKit
import AOCocoa

class UIAOImageEdit: UIAOView,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    private var _value:String = ""
    var imageView:UIImageView?
    var onSelected:((UIAOImageEdit,UIImage)->Void)?
    var loadImage:((UIAOImageEdit,String)->Void)?
    
    var value:String{
        set{
            self._value = newValue
            self.imageView?.isHidden  =  false
            self.loadImage?(self,newValue)
        }
        get{
            return self._value
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
   
    override func draw(_ rect: CGRect) {
        
    }
 */
    
    func load(size:CGFloat){
        self.views = self.layoutHelper(name: "addBtn", h: "|-0-[?]-0-|", v: "|-0-[?]-0-|", views: self.views, delegate: { (v:UIAOButton) in
            v.layer.borderColor = AppDefault.DefaultBlue.cgColor
            v.layer.borderWidth = 1
            let left = (size - 30) * 0.5
            let top = ( size - 2) * 0.5
            v.views = v.layoutHelper(name: "h", h:"|-\(left)-[?(30)]" , v: "|-\(top)-[?(2)]", views: v.views, delegate: { (vv:UIImageView) in
                vv.image = Utils.createImage(with: AppDefault.DefaultBlue)
            })
            
            v.views = v.layoutHelper(name: "v", h: "|-\(top)-[?(2)]", v: "|-\(left)-[?(30)]", views: self.views, delegate: { (vv:UIImageView) in
                vv.image = Utils.createImage(with: AppDefault.DefaultBlue)
            })
            
            v.views = v.layoutHelper(name: "image", h: "|-0-[?]-0-|", v: "|-0-[?]-0-|", views: v.views, delegate: { (vv:UIImageView) in
                imageView  = vv
            })
            
            self.click(v) {
                self.showBottomAlert()
            }
        })
        
       
    }
    
    func showBottomAlert(){
        let alertController=UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel=UIAlertAction(title:"取消", style: .cancel, handler: nil)
        let takingPictures=UIAlertAction(title:"拍照", style: .default)
        {
            action in
            self.goCamera()
            
        }
        let localPhoto=UIAlertAction(title:"本地图片", style: .default)
        {
            action in
            self.goImage()
            
        }
        alertController.addAction(cancel)
        alertController.addAction(takingPictures)
        alertController.addAction(localPhoto)
        self.vController?.present(alertController, animated:true, completion:nil)
        
    }
    
    func goCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let  cameraPicker = UIImagePickerController()
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = .camera
            //在需要的地方present出来
            self.vController?.present(cameraPicker, animated: true, completion: nil)
        } else {
            print("不支持拍照")
        }
        
    }
    
    func goImage(){
        let photoPicker =  UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.allowsEditing = true
        photoPicker.sourceType = .photoLibrary
        //在需要的地方present出来
        self.vController?.present(photoPicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image : UIImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        //显示设置的照片
        self.onSelected?(self,image)
        self.vController?.dismiss(animated: true, completion: nil)
    }
}
