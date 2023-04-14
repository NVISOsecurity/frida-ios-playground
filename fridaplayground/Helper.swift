//
//  Helper.swift
//  fridaplayground
//
//  Created by Jeroen Beckers on 05/04/2023.
//


import Foundation
import UIKit
//
//class func alertMessage(title: String, message: String) {
//    let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
//    let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
//    }
//    alertVC.addAction(okAction)
//
//
//    viewController.present(alertVC, animated: true, completion: nil)
//}


@objc class Helper : NSObject {
    static var app: Helper = {
        return Helper()
    }()
    
    static let vault = VulnerableVault()
  
    @objc func showMessage(msg: String)
    {
        showAlert(title: "Success!", message: msg)

    }
    @objc func showSuccess(){
        showAlert(title: "Success!", message: "This challenge is solved.")
    }
    @objc func showFailure(){
        showAlert(title: "Too bad...", message: "You haven't solved the challenge.")
    }
    func showAlert(title: String, message:String) {
      let alert = UIAlertController(title: title, message: message,    preferredStyle: .alert)

      let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      
      alert.addAction(okAction)
      alert.addAction(cancelAction)
      
      let vc = UIApplication.shared.windows.first!.rootViewController!
      vc.present(alert, animated: true, completion: nil)
   }
}
