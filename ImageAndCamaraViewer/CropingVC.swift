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
        if let croppedCGImage = ShowImages.image?.cgImage?.cropping(to: cropArea){
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
            
            
        }, completion: { (true) in
            self.ShowBtnView.isHidden = true
            self.ShowButtons.setTitle("Photos", for: .normal)
        })
    }
    @IBAction func ShowButtons(_ sender: UIButton) {
        if ShowBtnView.transform == .identity{
            UIView.animate(withDuration: 0.5, animations: {
                self.ShowBtnView.transform = CGAffineTransform(translationX: 0, y: -100)
            }) { (true) in
            }
            ShowBtnView.isHidden = false
            self.ShowButtons.setTitle("Cancel", for: .normal)
        }
        else{
            UIView.animate(withDuration: 0.3, animations: {
                self.ShowBtnView.transform = .identity
                
                
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
    //For zoom
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return ShowImages
    }
    //MARK: -Closure
    var cropArea:CGRect{
        get{
            let factor = ShowImages.image!.size.width / CropingFrameView.frame.width
             let heightFactor = ShowImages.image!.size.height / view.frame.height
              let scale = scrollView.zoomScale
               let x = (CropingFrameView.frame.origin.x - ShowImages.frame.origin.x) * scale * factor
              let y = (CropingFrameView.frame.origin.y - ShowImages.frame.origin.y) * scale * factor
             let viewWidth = CropingFrameView.frame.size.width * factor * scale
            let viewHeight = CropingFrameView.frame.size.height * factor * heightFactor
        return CGRect(x: x, y: y , width: viewWidth, height: viewHeight)
        }
    }
}
