//
//  ViewController.swift
//  PlayerMatcher
//
//  Created by Burak on 18.06.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var userNameText: UITextField!
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
   
        signUpButton.layer.cornerRadius = 12
        signInButton.layer.cornerRadius = 12
    }
    
    
    
    @IBAction func signIn(_ sender: Any) {
    }
    
    @IBAction func signUp(_ sender: Any) {
    }
    
}

