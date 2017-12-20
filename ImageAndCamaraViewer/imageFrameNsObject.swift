//
//  imageFrameNsObject.swift
//  ImageAndCamaraViewer
//
//  Created by Rabeeh KP on 20/12/17.
//  Copyright © 2017 Rabeeh KP. All rights reserved.
//

import UIKit

class imageFrameNsObject: NSObject {
    
    //MARK: -ImageFrame set
    func imageFrames(imageView : UIImageView)->CGRect{
        let imageViewSize = imageView.frame.size
        guard let imageSize = imageView.image?.size else{return CGRect.zero}
        let imageRatio = imageSize.width / imageSize.height
        let imageViewRatio = imageViewSize.width / imageViewSize.height
        if imageRatio < imageViewRatio {
            let scaleFactor = imageViewSize.height / imageSize.height
            let width = imageSize.width * scaleFactor
            let topLeftX = (imageViewSize.width - width) * 0.5
            return CGRect(x: topLeftX, y: 0, width: width, height: imageViewSize.height)
        }else{
            let scalFactor = imageViewSize.width / imageSize.width
            let height = imageSize.height * scalFactor
            let topLeftY = (imageViewSize.height - height) * 0.5
            return CGRect(x: 0, y: topLeftY, width: imageViewSize.width, height: height)
        }
    }
    
    //MARK: -Library Load
    func PhotoLoad( vcSelf : UIViewController){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
    
            imagePicker.delegate = vcSelf as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            vcSelf.present(imagePicker, animated: true, completion: nil)
        }
    }

    //MARK: -Camara Load
    func CameraLoad( vcSelf : UIViewController){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
        
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = vcSelf as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            vcSelf.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //MARK: -Button Animation
    func AnimationTransform(ShowBtnView: UIView,ShowButtons:UIButton){
        if ShowBtnView.transform == .identity {
            UIView.animate(withDuration: 0.3, animations: {
                ShowBtnView.transform = CGAffineTransform(translationX: 0, y: -100)
            }) { (true) in
            }
            ShowBtnView.isHidden = false
            ShowButtons.setTitle("Cancel", for: .normal)
        }
        else{
            UIView.animate(withDuration: 0.3, animations: {
                ShowBtnView.transform = .identity
            }, completion: { (true) in
                ShowBtnView.isHidden = true
                ShowButtons.setTitle("Photos", for: .normal)
            })
        }
    }
    
    //MARK: -Layer Changes
    func layerChanges(ShowCamera : UIButton , ShowDeviceGallery: UIButton, ShowButtons: UIButton, ShowBtnView: UIView, CropingFrameView: UIView){
        ShowCamera.layer.cornerRadius = 12
        ShowDeviceGallery.layer.cornerRadius = 12
        ShowButtons.layer.cornerRadius = 12
        ShowBtnView.isHidden = true
        CropingFrameView.layer.borderColor = UIColor.white.cgColor
        CropingFrameView.layer.borderWidth = 2
    }
    //MARK: -IF Condition
    func imageNilNot(CropButton: UIBarButtonItem, ClearButton : UIBarButtonItem , ShowImages :UIImageView){
        if ShowImages.image == nil{
            CropButton.isEnabled = false
            ClearButton.isEnabled = false
        }else{
            CropButton.isEnabled = true
            ClearButton.isEnabled = true
        }
    }
    
}
