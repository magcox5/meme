//
//  ViewController.swift
//  PickImageExperiment
//
//  Created by Molly Cox on 4/4/16.
//  Copyright © 2016 Molly Cox. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    @IBAction func pickAnImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        self.presentViewController(pickerController, animated: true, completion:nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
        memeImageView.image = image
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

}

