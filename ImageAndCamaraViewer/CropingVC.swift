//
//  CropingVC.swift
//  ImageAndCamaraViewer
//
//  Created by Rabeeh KP on 12/12/17.
//  Copyright © 2017 Rabeeh KP. All rights reserved.
//

import UIKit

class CropingVC: UIViewController , UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    //MARK: -Variables
    var imageViewScaleCurrent: CGFloat! = 1.0;
    var imageViewScaleMin: CGFloat! = 0.5;
    var imageViewScaleMax: CGFloat! = 5.0;
    
    //MARK: -Outlets
    @IBOutlet weak var SubView: UIView!
    @IBOutlet weak var CropingFrameView: UIView!
    @IBOutlet weak var ShowImages: UIImageView!
    @IBOutlet weak var ShowButtons: UIButton!
    @IBOutlet weak var ShowCamera: UIButton!
    @IBOutlet weak var ShowDeviceGallery: UIButton!
    @IBOutlet weak var ShowBtnView: UIView!
    @IBOutlet weak var ClearButton: UIBarButtonItem!
    @IBOutlet weak var CropButton: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
            scrollView.minimumZoomScale = 1.0
            scrollView.maximumZoomScale = 10.0
            scrollView.clipsToBounds = true
        }
    }
    
    //MARK: -ViewMethords
    override func viewDidLoad() {
        super.viewDidLoad()
        ShowCamera.layer.cornerRadius = 12
        ShowImages.layer.cornerRadius = 22
        ShowDeviceGallery.layer.cornerRadius = 12
        ShowButtons.layer.cornerRadius = 12
        ShowBtnView.isHidden = true
        CropingFrameView.layer.borderColor = UIColor.white.cgColor
        CropingFrameView.layer.borderWidth = 2
        //
        if ShowImages.image == nil{
            CropButton.isEnabled = false
            ClearButton.isEnabled = false
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
       
        if ShowImages.image != nil{
            CropButton.isEnabled = true
            ClearButton.isEnabled = true
        }
    }
    //MARK: -Actions
    @IBAction func CropBtn(_ sender: UIBarButtonItem) {
        var img = UIImage ()
        let originalOrientation = self.ShowImages.image?.imageOrientation
        if let croppedCGImage = ShowImages.image?.cgImage?.cropping(to: CropArea){
            //let croppedImage = UIImage(cgImage: croppedCGImage)
            let croppedImage = UIImage(cgImage: croppedCGImage, scale: (self.ShowImages.image?.scale)!, orientation: (originalOrientation)!)
            img = croppedImage
        }
        
        let  storyboard =  UIStoryboard(name: "Main", bundle: nil)
        let  destination = storyboard.instantiateViewController(withIdentifier: "ImgShowingVC") as! ImgShowingVC
        destination.recievingImg = img
        self.present(destination, animated: true, completion: nil)
        
    }
    @IBAction func ClearBtn(_ sender: UIBarButtonItem) {
        ShowImages.image = nil
        if ShowImages.image == nil{
            CropButton.isEnabled = false
            ClearButton.isEnabled = false
        }
        if ShowBtnView.transform != .identity{
        UIView.animate(withDuration: 0.3, animations: {
            self.ShowBtnView.transform = .identity
            
            
        }, completion: { (true) in
            self.ShowBtnView.isHidden = true
            self.ShowButtons.setTitle("Photos", for: .normal)
        })
        }
        scrollView.zoomScale = 1
    }
    @IBAction func ShowDeviceGalleryBtn(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.ShowBtnView.transform = .identity
            self.ShowCamera.setTitle("Photos", for: .normal)
            
        }, completion: { (true) in
            self.ShowBtnView.isHidden = true
            self.ShowButtons.setTitle("Photos", for: .normal)
        })
    }
    @IBAction func ShowCamaraBtn(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.ShowBtnView.transform = .identity
            self.ShowCamera.setTitle("Photos", for: .normal)
            
        }, completion: { (true) in
            self.ShowBtnView.isHidden = true
            self.ShowButtons.setTitle("Photos", for: .normal)
        })
    }
    @IBAction func ShowButtons(_ sender: UIButton) {
        if ShowBtnView.transform == .identity{
            UIView.animate(withDuration: 0.3, animations: {
                self.ShowBtnView.transform = CGAffineTransform(translationX: 0, y: -100)
                self.ShowCamera.setTitle("Camera", for: .normal)
            }) { (true) in
            }
            ShowBtnView.isHidden = false
            self.ShowButtons.setTitle("Cancel", for: .normal)
        }
        else{
            UIView.animate(withDuration: 0.3, animations: {
                self.ShowBtnView.transform = .identity
                self.ShowCamera.setTitle("Photos", for: .normal)
                
            }, completion: { (true) in
                self.ShowBtnView.isHidden = true
                self.ShowButtons.setTitle("Photos", for: .normal)
            })
        }
    }
    
    //MARK: -Functions
     //Show image in img view from camara and device
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        ShowImages.image = image
        dismiss(animated:true, completion: nil)
    }
    // Zoom images
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return ShowImages
    }
    //MARK: -Closure
     // croping images here
    var cropArea:CGRect{
        get{
            let heightFactor = ShowImages.image!.size.height / self.view.frame.height
            let factors = self.ShowImages.image!.size.width / self.view.frame.width
            let scales = 1 / self.scrollView.zoomScale
            let ImgScale = (ShowImages.image?.scale)!
            let xx = ( scrollView.contentOffset.x + self.CropingFrameView.frame.origin.x - self.ShowImages.frame.origin.x) * ImgScale * scales * factors
            let yy = (scrollView.contentOffset.y + self.CropingFrameView.frame.origin.y - self.ShowImages.frame.origin.y) * ImgScale * scales * heightFactor
            let width = self.CropingFrameView.frame.size.width * scales * factors
            let height = self.CropingFrameView.frame.size.height * scales * factors
            return CGRect(x: xx, y: yy, width: width, height: height)
        }
    }
    var CropArea:CGRect{
        get{
            let factor = ShowImages.image!.size.width/view.frame.width
            let scale = 1/scrollView.zoomScale
            let ImgScale = (ShowImages.image?.scale)!
            let imageFrame = ShowImages.imageFrame()
            let x = (scrollView.contentOffset.x + CropingFrameView.frame.origin.x - imageFrame.origin.x) * scale * factor
            let y = (scrollView.contentOffset.y + CropingFrameView.frame.origin.y - imageFrame.origin.y)  * scale * factor
            let width = CropingFrameView.frame.size.width * scale * factor
            let height = CropingFrameView.frame.size.height * scale * factor
            return CGRect(x: x, y: y, width: width, height: height)
        }
    }
}
extension UIImageView{
    func imageFrame()->CGRect{
        let imageViewSize = self.frame.size
        guard let imageSize = self.image?.size else{return CGRect.zero}
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
}

