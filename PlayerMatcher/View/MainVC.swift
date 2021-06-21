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
        activityIndicator.stopAnimating()
    }
    
    @IBAction func searchPlayer(_ sender: Any) {
        activityIndicator.startAnimating()
        WebService.shared.test { result in
            DispatchQueue.main.async {
                self.matchedPlayerInfo.isHidden = false
                self.matchedPlayerInfo.text = result
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }
    }
    

}
