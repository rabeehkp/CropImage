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
    var zoomScale = Int()
    var Functions = imageFrameNsObject()
    
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
            scrollView.maximumZoomScale = 6.0
            scrollView.clipsToBounds = true
        }
    }
    
    
    //MARK: -ViewMethords
    override func viewDidLoad() {
        super.viewDidLoad()
        Functions.layerChanges(ShowCamera: ShowCamera, ShowDeviceGallery: ShowDeviceGallery, ShowButtons: ShowButtons, ShowBtnView: ShowBtnView, CropingFrameView: CropingFrameView)
        Functions.imageNilNot(CropButton: CropButton, ClearButton: ClearButton, ShowImages: ShowImages)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Functions.imageNilNot(CropButton: CropButton, ClearButton: ClearButton, ShowImages: ShowImages)
    }
    
    //MARK: -Actions
    //crop image
    @IBAction func CropBtn(_ sender: UIBarButtonItem) {
        var img = UIImage ()
        if let originalOrientation = self.ShowImages.image?.imageOrientation, let scale = self.ShowImages.image?.scale ,let croppedCGImage = ShowImages.image?.cgImage?.cropping(to: CropArea) {
            let croppedImage = UIImage(cgImage: croppedCGImage, scale: (scale), orientation: (originalOrientation))
            img = croppedImage
            }
        //Navigation
        self.ImgShowingVC(img: img)
    }
    //clear imageview
    @IBAction func ClearBtn(_ sender: UIBarButtonItem) {
        ShowImages.image = nil
        Functions.imageNilNot(CropButton: CropButton, ClearButton: ClearButton, ShowImages: ShowImages)
        
        if ShowBtnView.transform != .identity{
            //Button animation
            Functions.AnimationTransform(ShowBtnView: ShowBtnView, ShowButtons: ShowButtons)
        }
        scrollView.zoomScale = 1
    }
    //Show image from device
    @IBAction func ShowDeviceGalleryBtn(_ sender: UIButton) {
        Functions.PhotoLoad(vcSelf: self)
        Functions.AnimationTransform(ShowBtnView: ShowBtnView, ShowButtons: ShowButtons)
    }
    
    // show camara
    @IBAction func ShowCamaraBtn(_ sender: UIButton) {
        Functions.CameraLoad(vcSelf: self)
        Functions.AnimationTransform(ShowBtnView: ShowBtnView, ShowButtons: ShowButtons)
    }
    //Animation button
    @IBAction func ShowButtons(_ sender: UIButton) {
        Functions.AnimationTransform(ShowBtnView: ShowBtnView, ShowButtons: ShowButtons)
//        if ShowBtnView.transform == .identity{
//            Functions.AnimationTransform(ShowBtnView: ShowBtnView, ShowButtons: ShowButtons)
//        }
//        else{
//            Functions.AnimationToIdentity(button: ShowButtons, view: ShowBtnView)
//        }
    }
    //MARK: -ImagePicker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
        ShowImages.image = image
        }
        dismiss(animated:true, completion: nil)
    }
    
    //MARK: -ScrollView Delegates
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return ShowImages
    }
    
    //MARK: -CropArea
    // croping images here
    
    var CropArea:CGRect{
        get{
            var factor = CGFloat()
            if let image = ShowImages.image{
            factor = image.size.width/view.frame.width
            }
            let scale = 1/scrollView.zoomScale
            let imageFrame = Functions.imageFrames(imageView: ShowImages)
            let x = (scrollView.contentOffset.x + CropingFrameView.frame.origin.x - imageFrame.origin.x) * scale * factor
            let y = (scrollView.contentOffset.y + CropingFrameView.frame.origin.y - imageFrame.origin.y)  * scale * factor
            let width = CropingFrameView.frame.size.width * scale * factor
            let height = CropingFrameView.frame.size.height * scale * factor
            return CGRect(x: x, y: y, width: width, height: height)
        }
    }
    
    //MARK: -Functions
    func ImgShowingVC ( img :UIImage ){
        let  storyboard =  UIStoryboard(name: "Main", bundle: nil)
        if let  destination = storyboard.instantiateViewController(withIdentifier: "ImgShowingVC") as? ImgShowingVC{
            destination.recievingImg = img
            self.present(destination, animated: true, completion: nil)
        }
    }
    
}

