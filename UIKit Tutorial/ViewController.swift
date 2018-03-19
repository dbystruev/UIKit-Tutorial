//
//  ViewController.swift
//  UIKit Tutorial
//
//  Created by Denis Bystruev on 18/03/2018.
//  Copyright © 2018 Denis Bystruev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var letNameLabel: UILabel!
    @IBOutlet weak var letNameTextField: UITextField!
    @IBOutlet weak var helloMessageTextField: UITextField!
    @IBOutlet weak var label: UILabel!
    
    @IBAction func textFieldsChanged(_ sender: UITextField) {
        updateLabels()
    }
    
    // Editing finished — close the keyboard
    @IBAction func editingDidEnd(_ sender: UITextField) {
        letNameTextField.resignFirstResponder()
        helloMessageTextField.resignFirstResponder()
        updateLabels()
    }
    
    // Allow rotation only for higher resolution
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        // allow rotation for iPhone Plus and iPad only
        // iPhone 6s Plus has 1242 x 2208 pixels at @3X
        // which equals to 414 x 736 points
        // https://developer.apple.com/ios/human-interface-guidelines/visual-design/adaptivity-and-layout/
        if view.frame.width < 414 {
            return .portrait
        } else {
            return .all
        }
    }
    
    // Enter is pressed — close the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    // Touch outside of text fields — close the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // Update text of letName and helloMessage labels
    func updateLabels() {
        letNameLabel.text = letNameTextField.text
        label.text = helloMessageTextField.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ready to resize the view on keyboard appearance
        setupViewResizerOnKeyboardShown()
        
        letNameTextField.delegate = self
        helloMessageTextField.delegate = self
        updateLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// Resize the view on keyboard appearance
// https://newfivefour.com/swift-ios-xcode-resizing-on-keyboard.html
// https://www.hackingwithswift.com/example-code/uikit/how-to-adjust-a-uiscrollview-to-fit-the-keyboard
extension UIViewController {
    
    @objc func keyboardWillResize(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let window = view.window?.frame {
            
            let height: CGFloat
            
            if notification.name == .UIKeyboardWillShow {
                // We're not just minusing the kb height from the view height because
                // the view could already have been resized for the keyboard before
                height = window.origin.y + window.height - keyboardSize.height
            } else {
                let viewHeight = view.frame.height
                height = viewHeight + keyboardSize.height
            }
            
            view.frame = CGRect(
                x: view.frame.origin.x,
                y: view.frame.origin.y,
                width: view.frame.width,
                height: height
            )
        }
    }
    
    func setupViewResizerOnKeyboardShown() {
        
        let names: [NSNotification.Name] = [
            .UIKeyboardWillShow,
            .UIKeyboardWillHide
        ]
    
        for name in names {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(keyboardWillResize),
                name: name,
                object: nil
            )
        }
    }

}

