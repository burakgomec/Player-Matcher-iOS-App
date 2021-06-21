//
//  Extensions.swift
//  PlayerMatcher
//
//  Created by Burak on 18.06.2021.
//

import Foundation
import UIKit

extension UIViewController{
    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
