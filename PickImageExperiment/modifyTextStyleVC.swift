//
//  ModifyTextStyleVC.swift
//  MemeMento
//
//  Created by Molly Cox on 5/7/16.
//  Copyright © 2016 Molly Cox. All rights reserved.
//

//
//  ViewController.swift
//  TestTextModify
//
//  Created by Molly Cox on 5/2/16.
//  Copyright © 2016 Molly Cox. All rights reserved.
//

import UIKit

class ModifyTextStyleVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    //  Declare variables and outlets
    let fontSize: CGFloat = 30.0
    
    let testTextAttributes: [String: AnyObject] = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSBackgroundColorAttributeName : UIColor.clearColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
        NSStrokeWidthAttributeName : -3.0
    ]

    weak var firstViewController : ViewController?
    
    @IBOutlet weak var textToModify: UITextField!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var fontChoices = ["Helvetica Neue", "American  Typewriter", "Helvetica", "Iowan Old Style", "Times New Roman"]
    
    var colorChoices = ["White", "Yellow", "Orange", "Red", "Green", "Blue", "Brown", "Black"]
    
    var colorChoices2 = [UIColor.whiteColor(), UIColor.yellowColor(), UIColor.orangeColor(), UIColor.redColor(), UIColor.greenColor(), UIColor.blueColor(), UIColor.brownColor(), UIColor.blackColor()]
    
    
    //  Actions
    @IBAction func okChangeText(sender: UIButton) {
        firstViewController?.topTitle.font = textToModify.font
        firstViewController?.topTitle.textColor = textToModify.textColor
        firstViewController?.bottomTitle.font = textToModify.font
        firstViewController?.bottomTitle.textColor = textToModify.textColor
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelChanges(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Methods for pickerView to display and choose font style and color
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (component == 0) {
            return fontChoices.count
        } else {
            return colorChoices.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (component == 0) {
            return "Font"
        } else {
            return "Color"
        }
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        if (component == 0) {
            let titleData = fontChoices[row]
            let myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName: UIColor.blueColor()])
            return myTitle
        } else {
            let titleData = colorChoices[row]
            let myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName: UIColor.blueColor()])
            return myTitle
        }
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        var myString = view as! UILabel!
        
        if( view == nil) {
            myString = UILabel()
        }
        if (component == 0) {
            myString.textAlignment = .Center
            
            let rowText = fontChoices[row]
            
            let attributedRowText = NSMutableAttributedString(string: rowText)
            let attributedRowTextLength = attributedRowText.length
            
            attributedRowText.addAttribute(NSFontAttributeName, value: UIFont(name: "Helvetica", size: 16.0)!, range: NSRange(location: 0 ,length:attributedRowTextLength))
            
            myString!.attributedText = attributedRowText
            
            return myString
        }
        else {
            myString.textAlignment = .Center
            
            let rowText = colorChoices[row]
            
            let attributedRowText = NSMutableAttributedString(string: rowText)
            let attributedRowTextLength = attributedRowText.length
            
            attributedRowText.addAttribute(NSFontAttributeName, value: UIFont(name: "Helvetica", size: 16.0)!, range: NSRange(location: 0 ,length:attributedRowTextLength))
            
            myString!.attributedText = attributedRowText
            
            return myString
            
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if (component == 0) {
            // Set Font Type
            textToModify.font = UIFont (name: fontChoices[row], size: fontSize)
        } else if (component == 1) {
            
            // Set Font Color
            textToModify.textColor = colorChoices2[row]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textToModify.defaultTextAttributes = testTextAttributes
        
    }
    
}
