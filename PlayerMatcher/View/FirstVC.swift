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
    
    @IBOutlet weak var groupStackView: UIStackView!
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
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
        if(userNameText.text?.trimmingCharacters(in: .whitespaces) != "" && emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines) != ""  && passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) != ""){
            WebService.shared.loginRequests(loginNumber: 1,username: userNameText.text!, email: emailText.text!, password: passwordText.text!) { control, result in
                if control{
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toMainVC", sender: nil)
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.makeAlert(title: "Error", message: result ?? "An error occurred")
                    }
                }
            }
        }
        else{
            self.makeAlert(title: "Error", message: "Please fill required fields")
        }
 
    }
    
    @IBAction func signUp(_ sender: Any) {
        if(userNameText.text?.trimmingCharacters(in: .whitespaces) != "" && emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines) != ""  && passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) != ""){
            WebService.shared.loginRequests(loginNumber: 2,username: userNameText.text!, email: emailText.text!, password: passwordText.text!) { control, result in
                if control{
                    DispatchQueue.main.async {
                        /*
                        UIView.animate(withDuration: 1) {
                            //self.makeAlert(title: "Success", message: "you have successfully registered")
                        } completion: { _ in
                            
                        }
                        */
                        self.performSegue(withIdentifier: "toMainVC", sender: nil)
                    }
                }
                else{
                    DispatchQueue.main.async {
                            self.makeAlert(title: "Error", message: result ?? "An error occurred")
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

