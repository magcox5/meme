//
//  ViewController.swift
//  PickImageExperiment
//
//  Created by Molly Cox on 4/4/16.
//  Copyright © 2016 Molly Cox. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    let memeTextAttributes: [String: AnyObject] = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
        NSStrokeWidthAttributeName : 2.0
    ]

    struct Meme {
        var topText: String
        var bottomText: String
        var memeImage: UIImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTitle.text = "TOP"
        bottomTitle.text = "BOTTOM"
        topTitle.defaultTextAttributes = memeTextAttributes
        bottomTitle.defaultTextAttributes = memeTextAttributes
        topTitle.textAlignment = .Center
        bottomTitle.textAlignment = .Center
        self.topTitle.delegate = self
        self.bottomTitle.delegate = self
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("addTapped"))
     }

    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }

    @IBOutlet weak var topTitle: UITextField!
    
    @IBOutlet weak var bottomTitle: UITextField!
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    @IBOutlet weak var chooseButton: UIBarButtonItem!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBAction func pickAnImage() {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
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

    @IBAction func pickAnImageFromCamera (sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func subscribeToKeyboardNotifications() {        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:))    ,
        name: UIKeyboardWillShowNotification, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:))    ,
           name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }

    func keyboardWillShow(notification: NSNotification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        // Reset to original position
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        if bottomTitle.editing {
            return keyboardSize.CGRectValue().height
        }
        else {
            return 0
        }
    }
    
    // Text Field Delegate Methods
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // Figure out what the new text will be, if we return true
        var newText: NSString = textField.text!
        newText = newText.stringByReplacingCharactersInRange(range, withString: string)
        
        // returning true gives the text field permission to change its text
        return true;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        resignFirstResponder()
        return true
    }
    
    func save() {
        //Create the meme
        let meme = Meme( topText: topTitle.text!, bottomText:  bottomTitle.text!, memeImage: memeImageView.image!)
    }
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        self.navigationController?.navigationBarHidden = true
        navigationController?.setToolbarHidden(true, animated: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO:  Show toolbar and navbar       
        self.navigationController?.navigationBarHidden = false
        navigationController?.setToolbarHidden(false, animated: false)
        
        
        return memedImage
    }
}

