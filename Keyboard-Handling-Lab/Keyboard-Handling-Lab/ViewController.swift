//
//  ViewController.swift
//  Keyboard-Handling-Lab
//
//  Created by Maitree Bain on 2/4/20.
//  Copyright © 2020 Maitree Bain. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var imageYConstraint: NSLayoutConstraint!
    
    private var origConstraint: CGFloat!
    
    private var keyboardIsVisible = false
    
    private lazy var tapGesture: UITapGestureRecognizer = {
       let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(tapActivated))
        return gesture
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForKeyboardNotifs()
        usernameText.delegate = self
        passwordText.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapActivated() {
        usernameText.resignFirstResponder()
        passwordText.resignFirstResponder()
        reset()
    }

    private func registerForKeyboardNotifs() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect else {
            return
        }
        moveKeyboardUp(keyboardFrame.size.height)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        reset()
    }
    
    private func unregisteredForKeyboardNotifs() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func moveKeyboardUp(_ height: CGFloat){
        if keyboardIsVisible { return }
        origConstraint = imageYConstraint.constant
        
        
        imageYConstraint.constant -= height * 0.6
        
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
        
        keyboardIsVisible = true
    }

    private func reset() {
        keyboardIsVisible = false
        
        imageYConstraint.constant = origConstraint
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    @IBAction func loginAction(_ sender: UIButton) {
        sender.isEnabled = false
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        reset()
        return true
    }
}
