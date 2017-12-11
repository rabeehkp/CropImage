//
//  ViewController.swift
//  ImageAndCamaraViewer
//
//  Created by Rabeeh KP on 09/12/17.
//  Copyright © 2017 Rabeeh KP. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    //MARK: -Variables
    var galleryBtnCenter: CGPoint!
    var cameraBtnCenter: CGPoint!
    var clicked: Bool = true
    //MARK: -Outlets
    @IBOutlet weak var ImagePreviewView: UIView!
    @IBOutlet weak var CaptureImageView: UIImageView!
    @IBOutlet weak var CaptureButton: UIButton!
    @IBOutlet weak var OpenPhotoLibrary: UIButton!
    @IBOutlet weak var SaveBtn: UIBarButtonItem!
    @IBOutlet weak var attachmentBtn: UIButton!
    
    
    
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
        let imageData = UIImageJPEGRepresentation(CaptureImageView.image!, 0.6)
        let compressedJPGImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        
        let alert = UIAlertView(title: "SAVED",
                                message: "Your image has been saved to Photo Library!",
                                delegate: nil,
                                cancelButtonTitle: "Ok")
        alert.show()
    }

    func changeImage(button: UIButton , onImage :UIImage, offImage: UIImage){
        if button.currentImage == offImage{
            button.setImage(onImage, for: .normal)
        }
        else{
            button.setImage(offImage, for: .normal)
        }
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

