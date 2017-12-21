//
//  imageFrameNsObject.swift
//  ImageAndCamaraViewer
//
//  Created by Rabeeh KP on 20/12/17.
//  Copyright © 2017 Rabeeh KP. All rights reserved.
//

import UIKit

class ImageFrameNsObject: NSObject {
    //MARK: -Variables
    var clicked : Bool = true
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
        }
        else{
            let scalFactor = imageViewSize.width / imageSize.width
            let height = imageSize.height * scalFactor
            let topLeftY = (imageViewSize.height - height) * 0.5
            return CGRect(x: 0, y: topLeftY, width: imageViewSize.width, height: height)
        }
    }
    
    //MARK: -Library and camera Load
    func photoLoad( vcSelf : UIViewController, buttonClicked : Bool  ){
        let check : UIImagePickerControllerSourceType = buttonClicked == true ? .camera : .photoLibrary
    
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = vcSelf as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = check
            imagePicker.allowsEditing = true
            vcSelf.present(imagePicker, animated: true, completion: nil)
        }
    
    
    //MARK: -Button Animation
    func animationTransform(showBtnView: UIView,showButtons:UIButton){
        if showBtnView.transform == .identity {
            UIView.animate(withDuration: 0.3, animations: {
                showBtnView.transform = CGAffineTransform(translationX: 0, y: -100)
            }) { (true) in
            }
            showBtnView.isHidden = false
            showButtons.setTitle("Cancel", for: .normal)
        }
        else{
            UIView.animate(withDuration: 0.3, animations: {
                showBtnView.transform = .identity
            }, completion: { (true) in
                showBtnView.isHidden = true
                showButtons.setTitle("Photos", for: .normal)
            })
        }
    }
    
    //MARK: -Layer Changes
    func layerChanges(showCamera : UIButton , showDeviceGallery: UIButton, showButtons: UIButton, showBtnView: UIView, cropingFrameView: UIView){
        showCamera.layer.cornerRadius = 12
        showDeviceGallery.layer.cornerRadius = 12
        showButtons.layer.cornerRadius = 12
        showBtnView.isHidden = true
        cropingFrameView.layer.borderColor = UIColor.white.cgColor
        cropingFrameView.layer.borderWidth = 2
    }
    //MARK: -IF Condition
    func imageNilNot(cropButton: UIBarButtonItem, clearButton : UIBarButtonItem , showImages :UIImageView){
        let visibility = showImages.image == nil ? false : true
        cropButton.isEnabled = visibility
        clearButton.isEnabled = visibility
    }
    
}
