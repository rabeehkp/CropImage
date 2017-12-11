//
//  CropImagesVC.swift
//  ImageAndCamaraViewer
//
//  Created by Rabeeh KP on 11/12/17.
//  Copyright © 2017 Rabeeh KP. All rights reserved.
//

import UIKit

class CropImagesVC: UIViewController , UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    //MARK: -Variables
   
    
    //MARK: -Outlets
    @IBOutlet weak var cropView: UIView!
    @IBOutlet weak var CropImagesView: UIImageView!
     @IBOutlet weak var attachmentsView: UIView!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var attachmentButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var BtnView: UIView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    //MARK: -ViewMethords
    override func viewDidLoad() {
        super.viewDidLoad()

       attachmentsView.isHidden = true
        attachmentsView.layer.cornerRadius = 22
        BtnView.layer.cornerRadius = 38
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -Action
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
    @IBAction func CameraViewBtn(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            
    }
        self.attachmentsView.isHidden = true
        self.attachmentsView.transform = .identity
        }
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
                self.attachmentsView.isHidden = true
                self.attachmentButton.transform = .identity
                self.attachmentsView.transform = .identity
                
            }, completion: { (true) in
                
            })
            
            
        }
        
        
    }
    @IBAction func cancelBtn(_ sender: UIBarButtonItem) {
    }
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
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        CropImagesView.image = image
        dismiss(animated:true, completion: nil)
    }
    func radians(degrees: Double) -> CGFloat{
        return CGFloat(degrees * .pi/degrees)
    }
    
    
    
    

}
