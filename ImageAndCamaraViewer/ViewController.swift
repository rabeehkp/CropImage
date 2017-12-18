//
//  ViewController.swift
//  ImageAndCamaraViewer
//
//  Created by Rabeeh KP on 09/12/17.
//  Copyright © 2017 Rabeeh KP. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIScrollViewDelegate {
    //MARK: -Variables
    var galleryBtnCenter: CGPoint!
    var cameraBtnCenter: CGPoint!
    var clicked: Bool = true
    //MARK: -Outlets
    @IBOutlet weak var ImagePreviewView: UIView!
    @IBOutlet weak var CropImagesView: UIView!
    @IBOutlet weak var CaptureImageView: UIImageView!
    @IBOutlet weak var CaptureButton: UIButton!
    @IBOutlet weak var OpenPhotoLibrary: UIButton!
    @IBOutlet weak var SaveBtn: UIBarButtonItem!
    @IBOutlet weak var CropBtn: UIButton!
    @IBOutlet weak var attachmentBtn: UIButton!
    @IBOutlet weak var ScrollView: UIScrollView!{
        didSet{
            ScrollView.delegate = self
                        ScrollView.minimumZoomScale = 1.0
                        ScrollView.maximumZoomScale = 10.0
        }
    }
    
    
    //MARK: -ViewMethords
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        galleryBtnCenter = OpenPhotoLibrary.center
        cameraBtnCenter = CaptureButton.center
        
        OpenPhotoLibrary.center = attachmentBtn.center
        CaptureButton.center = attachmentBtn.center
        CaptureButton.layer.cornerRadius = 25
        OpenPhotoLibrary.layer.cornerRadius = 25
        attachmentBtn.layer.cornerRadius = 25
        CropImagesView.layer.borderColor = UIColor.white.cgColor
        CropImagesView.layer.borderWidth = 2
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
      
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: -Action
    
    @IBAction func attachmentButton(_ sender: UIButton) {
        
        if attachmentBtn.currentImage == #imageLiteral(resourceName: "attachment(color)"){
            UIView.animate(withDuration: 0.5, animations: {
                self.CaptureButton.alpha = 1
                self.OpenPhotoLibrary.alpha = 1
                self.CaptureButton.center = self.cameraBtnCenter
                self.OpenPhotoLibrary.center = self.galleryBtnCenter
                
            })
            
        }else{
            UIView.animate(withDuration: 0.4, animations: {
                self.CaptureButton.alpha = 0
                self.OpenPhotoLibrary.alpha = 0
                self.CaptureButton.center = self.attachmentBtn.center
                self.OpenPhotoLibrary.center = self.attachmentBtn.center
            })
        }
       changeImage(button: sender, onImage: #imageLiteral(resourceName: "attachment(color)"), offImage: #imageLiteral(resourceName: "attachment(Black)"))
    }
    @IBAction func openCameraButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    @IBAction func openPhotoLibraryButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
//   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        CaptureImageView.image = image
        dismiss(animated:true, completion: nil)
    }
    @IBAction func saveButt(sender: AnyObject) {
        let originalOrientation = self.CaptureImageView.image?.imageOrientation
        
        var img = UIImage ()
        if let croppedCGImage = CaptureImageView.image?.cgImage?.cropping(to: cropArea){
            //let croppedImage = UIImage(cgImage: croppedCGImage)
            let CroppedImage = UIImage(cgImage: croppedCGImage, scale: (self.CaptureImageView.image?.scale)!, orientation: (originalOrientation)!)
            img = CroppedImage
        }
        
        let  storyboard =  UIStoryboard(name: "Main", bundle: nil)
        let  destination = storyboard.instantiateViewController(withIdentifier: "ImgShowingVC") as! ImgShowingVC
        destination.recievingImg = img
        self.present(destination, animated: true, completion: nil)
        
    }

    func changeImage(button: UIButton , onImage :UIImage, offImage: UIImage){
        if button.currentImage == offImage{
            button.setImage(onImage, for: .normal)
        }
        else{
            button.setImage(offImage, for: .normal)
        }
    }
    
    //
    
    @IBAction func cropBtn(_ sender: UIButton) {
        //change to crop button
        
    }
    //MARK: -Closure create
    var cropArea:CGRect{
        get{
            let factor = CaptureImageView.image!.size.width / ImagePreviewView.frame.width
            let heightFactor = CaptureImageView.image!.size.height / view.frame.height
            let scale = ScrollView.zoomScale
            
            let x = (CropImagesView.frame.origin.x - CaptureImageView.frame.origin.x) * scale * factor
            let y = (CropImagesView.frame.origin.y - CaptureImageView.frame.origin.y) * scale * factor
            let viewWidth = CropImagesView.frame.size.width * factor * scale
            let viewHeight = CropImagesView.frame.size.height * factor // * heightFactor  * calcHeight
            return CGRect(x: x, y: y, width: viewWidth, height: viewHeight)
            
        }
    }
    
    //
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
                return CaptureImageView
            }

}
//extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//
//    func thisIsTheFunctionWeAreCalling() {
//        let camera = CamaraHandler(delegate_: self)
//        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        optionMenu.popoverPresentationController?.sourceView = self.view
//
//        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (alert : UIAlertAction!) in
//            camera.getCameraOn(self, canEdit: true)
//        }
//        let sharePhoto = UIAlertAction(title: "Photo Library", style: .default) { (alert : UIAlertAction!) in
//            camera.getPhotoLibraryOn(self, canEdit: true)
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert : UIAlertAction!) in
//        }
//        optionMenu.addAction(takePhoto)
//        optionMenu.addAction(sharePhoto)
//        optionMenu.addAction(cancelAction)
//        self.present(optionMenu, animated: true, completion: nil)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//
//        let image = info[UIImagePickerControllerEditedImage] as! UIImage
//
//        // image is our desired image
//
//        picker.dismiss(animated: true, completion: nil)
//    }
//}

