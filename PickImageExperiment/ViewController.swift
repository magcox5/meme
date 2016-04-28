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
        NSBackgroundColorAttributeName : UIColor.clearColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
        NSStrokeWidthAttributeName : 3.0
    ]

    struct Meme {
        var topText: String?
        var bottomText: String?
        var originalImage: UIImage?
        var memeImage: UIImage!
    }
    
    func getTopText() {
        topTitle.text = "TOP"
    }
    
    func getBottomText() {
        bottomTitle.text = "BOTTOM"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getTopText()
        getBottomText()
        topTitle.defaultTextAttributes = memeTextAttributes
        bottomTitle.defaultTextAttributes = memeTextAttributes
        topTitle.textAlignment = .Center
        topTitle.textColor = UIColor.whiteColor()
        bottomTitle.textAlignment = .Center
        bottomTitle.textColor = UIColor.whiteColor()
        self.topTitle.delegate = self
        self.bottomTitle.delegate = self
     }

    override func viewWillAppear(animated: Bool) {
        // Disable the camera button if no camera exists
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    // Outlets

    @IBOutlet weak var topTitle: UITextField!
    
    @IBOutlet weak var bottomTitle: UITextField!
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    @IBOutlet weak var chooseButton: UIBarButtonItem!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!

    // Actions
    
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
        self.navigationItem.leftBarButtonItem!.enabled = true
    }

    @IBAction func pickAnImageFromCamera (sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func shareMeme(sender: AnyObject) {
        //Create a variable to generate a memed image
        let imageToShare = generateMemedImage()
        //Define an instance of the ActivityViewController
        //& pass the ActivityViewController a memedImage as an activity item
        let myController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: [])
        //Present the ActivityViewController
        presentViewController(myController, animated: true, completion: nil)
        
        //If the action completed successfully, save the meme
        myController.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[AnyObject]?, error: NSError?) in
            
            // Return if cancelled
            if (completed) {
                self.save()
            }
            self.dismissViewControllerAnimated(true, completion:nil)
        }
        
    }
    
    @IBAction func cancelMeme(sender: UIBarButtonItem) {
        // Remove image and restore top and bottom titles to original state
        memeImageView.image = nil
        getTopText()
        getBottomText()
    }
    

    // Subscribe to keyboard notifications so keyboard can be 
    // moved up when editing bottom title
    func subscribeToKeyboardNotifications() {        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:))    ,
        name: UIKeyboardWillShowNotification, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:))    ,
           name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)

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
        // Create the meme
        _ = Meme( topText: topTitle.text!, bottomText:  bottomTitle.text!, originalImage: self.memeImageView.image, memeImage: generateMemedImage())
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        self.navigationController?.navigationBarHidden = true
        navigationController?.setToolbarHidden(true, animated: true)
        self.chooseButton.enabled = false
        self.cameraButton.enabled = false
        self.chooseButton.tintColor = UIColor.clearColor()
        self.cameraButton.tintColor = UIColor.clearColor()
        
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //  Show toolbar and navbar
        self.navigationController?.navigationBarHidden = false
        navigationController?.setToolbarHidden(false, animated: false)
        self.chooseButton.enabled = true
        self.cameraButton.enabled = true
        self.chooseButton.tintColor = nil
        self.cameraButton.tintColor = nil
        
        
        return memedImage
    }
}

