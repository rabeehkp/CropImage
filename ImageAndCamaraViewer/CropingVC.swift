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
    var functions = ImageFrameNsObject()
    var cameraButtonClicked : Bool = false
//    var libraryButtonClicked : Bool = false
    
    //MARK: -Outlets
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var cropingFrameView: UIView!
    @IBOutlet weak var showImages: UIImageView!
    @IBOutlet weak var showButtons: UIButton!
    @IBOutlet weak var showCamera: UIButton!
    @IBOutlet weak var showDeviceGallery: UIButton!
    @IBOutlet weak var showBtnView: UIView!
    @IBOutlet weak var clearButton: UIBarButtonItem!
    @IBOutlet weak var cropButton: UIBarButtonItem!
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
        functions.layerChanges(showCamera: showCamera, showDeviceGallery: showDeviceGallery, showButtons: showButtons, showBtnView: showBtnView, cropingFrameView: cropingFrameView)
        functions.imageNilNot(cropButton: cropButton, clearButton: clearButton, showImages: showImages)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        functions.imageNilNot(cropButton: cropButton, clearButton: clearButton, showImages: showImages)
    }
    
    //MARK: -Button Actions
    //crop image
    @IBAction func cropBtn(_ sender: UIBarButtonItem) {
        var img = UIImage ()
        if let originalOrientation = self.showImages.image?.imageOrientation, let scale = self.showImages.image?.scale ,let croppedCGImage = showImages.image?.cgImage?.cropping(to: cropArea) {
            let croppedImage = UIImage(cgImage: croppedCGImage, scale: (scale), orientation: (originalOrientation))
            img = croppedImage
            }
        //Navigation
        self.ImgShowingVC(img: img)
    }
    //clear imageview
    @IBAction func clearBtn(_ sender: UIBarButtonItem) {
        showImages.image = nil
        functions.imageNilNot(cropButton: cropButton, clearButton: clearButton, showImages: showImages)
        
        if showBtnView.transform != .identity{
            //Button animation
            functions.animationTransform(showBtnView: showBtnView, showButtons: showButtons)
        }
        scrollView.zoomScale = 1
    }
    //Show image from device
    @IBAction func showDeviceGalleryBtn(_ sender: UIButton) {
        cameraButtonClicked = false
        if cameraButtonClicked == false{
            functions.photoLoad(vcSelf: self, buttonClicked: cameraButtonClicked)
        }
        functions.animationTransform(showBtnView: showBtnView, showButtons: showButtons)
    }
    
    // show camara
    @IBAction func showCamaraBtn(_ sender: UIButton) {
        cameraButtonClicked = true
        if cameraButtonClicked == true{
            functions.photoLoad(vcSelf: self, buttonClicked: cameraButtonClicked)
        }
        functions.animationTransform(showBtnView: showBtnView, showButtons: showButtons)
        
    }
    //Animation button
    @IBAction func showButtons(_ sender: UIButton) {
        functions.animationTransform(showBtnView: showBtnView, showButtons: showButtons)
    }
    //MARK: -ImagePicker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
        showImages.image = image
        }
        dismiss(animated:true, completion: nil)
    }
    
    //MARK: -ScrollView Delegates
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return showImages
    }
    
    //MARK: -CropArea
    // croping images here
    
    var cropArea:CGRect{
        get{
            var factor = CGFloat()
            if let image = showImages.image{
            factor = image.size.width/view.frame.width
            }
            let scale = 1/scrollView.zoomScale
            let imageFrame = functions.imageFrames(imageView: showImages)
            let x = (scrollView.contentOffset.x + cropingFrameView.frame.origin.x - imageFrame.origin.x) * scale * factor
            let y = (scrollView.contentOffset.y + cropingFrameView.frame.origin.y - imageFrame.origin.y)  * scale * factor
            let width = cropingFrameView.frame.size.width * scale * factor
            let height = cropingFrameView.frame.size.height * scale * factor
            return CGRect(x: x, y: y, width: width, height: height)
        }
    }
    
    //MARK: -Navigation functions
    func ImgShowingVC ( img :UIImage ){
        let  storyboard =  UIStoryboard(name: "Main", bundle: nil)
        if let  destination = storyboard.instantiateViewController(withIdentifier: "ImgShowingVC") as? ImgShowingVC{
            destination.recievingImg = img
            self.present(destination, animated: true, completion: nil)
        }
    }
    
}

