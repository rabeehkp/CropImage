//
//  ImgShowingVC.swift
//  ImageAndCamaraViewer
//
//  Created by Rabeeh KP on 13/12/17.
//  Copyright © 2017 Rabeeh KP. All rights reserved.
//

import UIKit

class ImgShowingVC: UIViewController {
    
    //MARK: -Variables
    var recievingImg = UIImage()
    
    @IBOutlet weak var SaveButton: UIBarButtonItem!
    //MARK: -Outlets
    @IBOutlet weak var CancelButton: UIBarButtonItem!
    @IBOutlet weak var ImgShowingView: UIImageView!
    
   
    //MARK: -ViewMethords
    override func viewDidLoad() {
        super.viewDidLoad()
        ImgShowingView.image = recievingImg

    }
    
    //MARK: -Action
    @IBAction func SaveBtn(_ sender: UIBarButtonItem) {
        dismiss(animated: false, completion: nil)
        //save croped images
        let imageData = UIImageJPEGRepresentation(ImgShowingView.image!, 0.6)
        let compressedJPGImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        let alert = UIAlertView(title: "SAVED",
                                message: "Your image has been saved to Photo Library!",
                                delegate: nil,
                                cancelButtonTitle: "Ok")
        alert.show()
    }
    @IBAction func CancelBtn(_ sender: UIBarButtonItem) {
        dismiss(animated: false, completion: nil)
    }
}
