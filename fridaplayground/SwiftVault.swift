//
//  SwiftVault.swift
//  fridaplayground
//
//  Created by Jeroen Beckers on 06/04/2023.
//

import Foundation
import SwiftUI

@objc class SwiftVault : NSObject
{
    static var vault: SwiftVault = {
        return SwiftVault()
    }()
    
    @objc func getSmallSecret() -> String {
        return "FRIDASWIFT";
    }
    @objc func getLargeSecret() -> String {
        return "LARGESTRINGSARENOTLIKESMALLSTRINGS";
    }
    @objc static func staticWin(){
        Helper.app.showSuccess();
    }
    
    @objc func win(){
        Helper.app.showSuccess();
    }
    
    var pinTextField: UITextField!
    @objc func askPin(){
        let vc = UIApplication.shared.windows.first!.rootViewController!
        let dialogMessage = UIAlertController(title: "Enter PIN", message: nil, preferredStyle: .alert)

            let Create = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
                if let chosenPin = self.pinTextField!.text {
                    let myIntPin = Int32(chosenPin) ?? 0
                    if Helper.vault.validate(myIntPin){
                        Helper.app.showSuccess()
                    }
                    else{
                        Helper.app.showFailure()
                    }
                }
            })
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) -> Void in
                
            }

            //Add OK and Cancel button to dialog message

            dialogMessage.addAction(Create)
            dialogMessage.addAction(cancel)
            // Add Input TextField to dialog message
            dialogMessage.addTextField { (textField) -> Void in
                self.pinTextField = textField
                self.pinTextField?.placeholder = "Please 4-digit PIN"
            }

            // Present dialog message to user
            vc.present(dialogMessage, animated: true, completion: nil)
    }
}
