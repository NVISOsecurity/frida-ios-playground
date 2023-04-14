//
//  ChallengeVault.swift
//  fridaplayground
//
//  Created by Jeroen Beckers on 07/04/2023.
//

import Foundation
import SwiftUI

class ChallengeVault
{
    var pwdTextField: UITextField!
    func challenge2(){
        let vc = UIApplication.shared.windows.first!.rootViewController!
        let dialogMessage = UIAlertController(title: "Enter Password", message: nil, preferredStyle: .alert)

            let Create = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
                if let chosenPwd = self.pwdTextField!.text {
                    
                    if self.validatePassword(key: chosenPwd) {
                        Helper.app.showSuccess()
                    }
                    else{
                        Helper.app.showFailure()
                    }
                }
            })
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) -> Void in
                
            }
            dialogMessage.addAction(cancel)
            dialogMessage.addAction(Create)
           
            // Add Input TextField to dialog message
            dialogMessage.addTextField { (textField) -> Void in
                self.pwdTextField = textField
                self.pwdTextField?.placeholder = "Please enter password"
            }

            // Present dialog message to user
            vc.present(dialogMessage, animated: true, completion: nil)
    
    }
    func validatePassword(key : String) -> Bool{
        
        guard key.count == 16 else {
            return false;
        }
        // Frida4Fun&Profit
        
        var ss = Int32(key[5..<6]) ?? 1000
        ss += Int32(validate1(prep(part: key[0..<5])))
        ss += Int32(validate2(prep(part: key[6..<9])))
        ss += Int32(validate3(prep(part: key[10..<key.count])))
        return (ss == 7) && key[9..<10] == "&"
        
    }
    
    func prep(part : String) -> UnsafeMutablePointer<CChar>
    {
        let s = part as NSString
        let key = UnsafeMutablePointer<CChar>(mutating: s.utf8String)
        return key!
    }
    
}




