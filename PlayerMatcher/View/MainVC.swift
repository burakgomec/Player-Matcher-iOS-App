//
//  MainVC.swift
//  PlayerMatcher
//
//  Created by Burak on 18.06.2021.
//

import UIKit

class MainVC: UIViewController {
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var matchedPlayerInfo: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func searchPlayer(_ sender: Any) {
        activityIndicator.startAnimating()
        WebService.shared.findPlayerRequest { control, player in
            if(control && player != nil){
                DispatchQueue.main.async {
                    let result = "Matched Player's Name: \(String(describing: player!.username))\n Matched Player's Level: \(String(describing: player!.level))\n" +
                    "Matched Player's Kd Ratio: \(String(describing: player!.kdRatio)) "
                    self.matchedPlayerInfo.isHidden = false
                    self.matchedPlayerInfo.text = result
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
            }
            else{
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.makeAlert(title: "Error", message: "An error occurred")
                }
            }
        }
    }
    
    
    @IBAction func increaseLevel(_ sender: Any) {
        WebService.shared.levelUpRequest { control, player in
            if control && player != nil{
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    let result = "You have reached level: \(String(describing: player!.level))"
                    self.makeAlert(title: "Your level has increased", message: result)
                }
            }
            else{
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.makeAlert(title: "Error", message: "An error occurred in server")
                }
            }
        }
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    
    @IBAction func logOut(_ sender: Any) {
        User.clearUserData()
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
