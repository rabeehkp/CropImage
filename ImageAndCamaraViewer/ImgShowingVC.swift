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
    
    @IBOutlet weak var Backbtn: UIButton!
    //MARK: -Outlets
    @IBOutlet weak var ImgShowingView: UIImageView!
    
    //MARK: -Action
    @IBAction func GoBackBtn(_ sender: UIButton) {
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
