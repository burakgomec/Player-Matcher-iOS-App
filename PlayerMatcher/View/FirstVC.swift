//
//  ViewController.swift
//  PlayerMatcher
//
//  Created by Burak on 18.06.2021.
//

import UIKit

class FirstVC: UIViewController {
    
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var generalStackView: UIStackView!
    
    
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userNameText.delegate = self
        emailText.delegate = self
        passwordText.delegate = self
        
        prepareForViewRadius()

        let endEditingGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        view.addGestureRecognizer(endEditingGesture)
    }
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        self.generalStackView.alpha = 1
        generalStackView.bounds.origin.x += self.view.bounds.width
        userNameText.text = ""
        emailText.text = ""
        passwordText.text = ""
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5, delay: 0.00, options: .curveLinear, animations: {
            self.generalStackView.bounds.origin.x -= self.view.bounds.width
            self.view.layoutIfNeeded()
            }, completion: nil)
    }

    func prepareForViewRadius(){
        signUpButton.layer.cornerRadius = 22
        signInButton.layer.cornerRadius = 22
        userNameText.layer.cornerRadius = 19
        passwordText.layer.cornerRadius = 19
        emailText.layer.cornerRadius = 19
        emailText.clipsToBounds = true
        passwordText.clipsToBounds = true
        userNameText.clipsToBounds = true
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward

    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
    @objc func endEditing(){
        view.endEditing(true)
    }
    
    @IBAction func signIn(_ sender: Any) {
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: .curveLinear, animations: {
                let bounds = self.signInButton.bounds
                self.signInButton.bounds = CGRect(x: bounds.origin.x - 10 , y: bounds.origin.y , width: bounds.size.width + 30 , height: bounds.size.height )
                self.signInButton.isEnabled = false
            }, completion: { _ in self.signInButton.isEnabled = true })
        
        if(userNameText.text?.trimmingCharacters(in: .whitespaces) != "" && emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines) != ""  && passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) != ""){
            
            UIView.animate(withDuration: 0.3,delay: 0, options: .curveEaseOut) {
                self.generalStackView.alpha = 0
            }

            WebService.shared.loginRequests(loginNumber: 1, username: userNameText.text!, email: emailText.text!, password: passwordText.text!) { control, result in
                if control{
                    DispatchQueue.main.async {                      
                        self.performSegue(withIdentifier: "toMainVC", sender: nil)
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.makeAlert(title: "Error", message: result ?? "An error occurred")
                        self.generalStackView.alpha = 1
                    }
                }
            }
        }
        else{
            self.makeAlert(title: "Error", message: "Please fill required fields")
        }
 
    }
    
    @IBAction func signUp(_ sender: Any) {
        
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: .curveLinear, animations: {
                let bounds = self.signUpButton.bounds
                self.signUpButton.bounds = CGRect(x: bounds.origin.x - 10 , y: bounds.origin.y , width: bounds.size.width + 30 , height: bounds.size.height )
                self.signUpButton.isEnabled = false
            }, completion: { _ in self.signUpButton.isEnabled = true })


       if(userNameText.text?.trimmingCharacters(in: .whitespaces) != "" && emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines) != ""  && passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) != ""){
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                self.generalStackView.alpha = 0
        }
            WebService.shared.loginRequests(loginNumber: 2,username: userNameText.text!, email: emailText.text!, password: passwordText.text!) { control, result in
                if control{
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toMainVC", sender: nil)
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.makeAlert(title: "Error", message: result ?? "An error occurred")
                        self.generalStackView.alpha = 1
                    }
                }
            }
        }
       
        else{
            self.makeAlert(title: "Error", message: "Please fill required fields")
        }
 
    }
    
    
    func switchBasedNextTextField(textField : UITextField){
        switch textField {
        case userNameText:
            emailText.becomeFirstResponder()
        case emailText:
            passwordText.becomeFirstResponder()
        default:
            passwordText.resignFirstResponder()
        }
    }
    
}

extension FirstVC : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchBasedNextTextField(textField: textField)
        return true
    }
    
}

