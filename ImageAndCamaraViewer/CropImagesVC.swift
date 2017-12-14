//
//  CropImagesVC.swift
//  ImageAndCamaraViewer
//
//  Created by Rabeeh KP on 11/12/17.
//  Copyright © 2017 Rabeeh KP. All rights reserved.
//

import UIKit

class CropImagesVC: UIViewController , UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate {

    //MARK: -Variables
   var attachmentViews: CGPoint!
    
    //MARK: -Outlets
    //
    @IBOutlet var cropAreaView: CropAreaView!
    //
    @IBOutlet weak var cropView: UIView!
    @IBOutlet weak var CropImagesView: UIImageView!
     @IBOutlet weak var attachmentsView: UIView!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var attachmentButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var BtnView: UIView!
    @IBOutlet weak var cropButton: UIBarButtonItem!
    @IBOutlet weak var croppingView: UIView!
    @IBOutlet weak var ScrollView: UIScrollView!{
        didSet{
            ScrollView.delegate = self
//            ScrollView.minimumZoomScale = 1.0
//            ScrollView.maximumZoomScale = 10.0
        }
    }
    
    
    
    //MARK: -ViewMethords
    override func viewDidLoad() {
        super.viewDidLoad()
        CropImagesView.contentMode = UIViewContentMode.scaleAspectFill
        CropImagesView.clipsToBounds = true
       attachmentsView.isHidden = true
        attachmentsView.layer.cornerRadius = 22
        BtnView.layer.cornerRadius = 38
        croppingView.layer.borderColor = UIColor.white.cgColor
        croppingView.layer.borderWidth = 2
        
        //animationChanging
//        attachmentViews = attachmentsView.center
//        attachmentsView.center = BtnView.center
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -Action
    
    //upload from device galary
    @IBAction func GalleryViewBtn(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        self.attachmentsView.isHidden = true
        self.attachmentsView.transform = .identity
    }
    // showing camera
    @IBAction func CameraViewBtn(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            
        }else{
            let alert = UIAlertView(title: "Camera Not Found",
                                    message: "No Camera",
                                    delegate: nil,
                                    cancelButtonTitle: "Ok")
        }
        self.attachmentsView.isHidden = true
        self.attachmentsView.transform = .identity
        }
    
    //Showing button with animation
    @IBAction func Attachmenttn(_ sender: UIButton) {
        if attachmentsView.transform == .identity{
            UIView.animate(withDuration: 0.3, animations: {
                self.attachmentsView.transform = CGAffineTransform(translationX: -230, y: -113)
                self.attachmentButton.transform = CGAffineTransform(rotationAngle: self.radians(degrees: 180))
            }) { (true) in
            }
            attachmentsView.isHidden = false
        } else{
            UIView.animate(withDuration: 0.5, animations: {
                
                self.attachmentButton.transform = .identity
                self.attachmentsView.transform = .identity
                 self.attachmentsView.isHidden = true
            }, completion: { (true) in
               
            })
            
        }
    }
    //croping button
    @IBAction func cropBtn(_ sender: UIBarButtonItem) {
        //change to crop button
        var img = UIImage ()
        if let croppedCGImage = CropImagesView.image?.cgImage?.cropping(to: cropArea){
        let croppedImage = UIImage(cgImage: croppedCGImage)
        //CropImagesView.image = croppedImage
            img = croppedImage
        }

        let  storyboard =  UIStoryboard(name: "Main", bundle: nil)
        let  destination = storyboard.instantiateViewController(withIdentifier: "ImgShowingVC") as! ImgShowingVC
        destination.recievingImg = img
        self.present(destination, animated: true, completion: nil)
        //croppingView.isHidden = true
        //ScrollView.zoomScale = 1
    }
    //MARK: -Closure create
    var cropArea:CGRect{
        get{
            let factor = CropImagesView.image!.size.width / view.frame.width
            let scale = 1 / ScrollView.zoomScale
           //let imageFrame = CropImagesView.imageFrame()
           let x = (croppingView.frame.origin.x - CropImagesView.frame.origin.x) * scale * factor
            let y = (croppingView.frame.origin.y - CropImagesView.frame.origin.y) * scale * factor
//            let width = croppingView.frame.size.width * scale * factor
//            let height = croppingView.frame.size.height * scale * factor
//            return CGRect(x: x, y: y, width: width, height: height)
            //
            let viewWidth = croppingView.frame.size.width * factor * scale
            let viewHeight = croppingView.frame.size.height * factor * scale
            
            return CGRect(x: x, y: y, width: viewWidth, height: viewHeight)
            //
            
            
        }
    }
    
    //save button
    @IBAction func saveBtn(_ sender: UIBarButtonItem) {
        let imageData = UIImageJPEGRepresentation(CropImagesView.image!, 0.6)
        let compressedJPGImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        
        let alert = UIAlertView(title: "SAVED",
                                message: "Your image has been saved to Photo Library!",
                                delegate: nil,
                                cancelButtonTitle: "Ok")
        alert.show()
    }
    
    //show image in image view
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        CropImagesView.image = image
        dismiss(animated:true, completion: nil)
    }
    
    // croping function
//    func cropImage(screenshot: UIImage) -> UIImage {
//        let crop = CGRect(x:-140,y:515,width:260,height:200)
//        //let cgImages = CGImageCreateWithImageInRect(screenshot.cgImage!, crop)
//        let cgImg = screenshot.cgImage?.cropping(to: crop)
//
//        let image: UIImage = UIImage(cgImage: cgImg!)
//        return image
//    }
    //crping frame
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return CropImagesView
//    }
    
    //Convert degree to float
    func radians(degrees: Double) -> CGFloat{
        return CGFloat(degrees * .pi/degrees)
    }

}
//extension UIImageView{
//    func imageFrame()->CGRect{
//        let imageViewSize = self.frame.size
//        guard let imageSize = self.image?.size else{return CGRect.zero}
//        let imageRatio = imageSize.width / imageSize.height
//        let imageViewRatio = imageViewSize.width / imageViewSize.height
//        if imageRatio < imageViewRatio {
//            let scaleFactor = imageViewSize.height / imageSize.height
//            let width = imageSize.width * scaleFactor
//            let topLeftX = (imageViewSize.width - width) * 0.5
//            return CGRect(x: topLeftX, y: 0, width: width, height: imageViewSize.height)
//        }else{
//            let scalFactor = imageViewSize.width / imageSize.width
//            let height = imageSize.height * scalFactor
//            let topLeftY = (imageViewSize.height - height) * 0.5
//            return CGRect(x: 0, y: topLeftY, width: imageViewSize.width, height: height)
//        }
//    }
//}

