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
    
    //MARK: -Action
    @IBAction func SaveBtn(_ sender: UIBarButtonItem) {
        dismiss(animated: false, completion: nil)
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ImgShowingView.image = recievingImg

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
