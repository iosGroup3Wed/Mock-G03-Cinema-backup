//
//  ChangePasswordViewController.swift
//  Mock_G03_Cinema
//
//  Created by Tran Van Tin on 6/2/17.
//  Copyright © 2017 Tran Van Tin. All rights reserved.
//

import UIKit
import Firebase

class ChangePasswordViewController: UIViewController {
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var newPasswordTextField: UITextField!
    @IBOutlet var oldPasswordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        resetTextField()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func confirmButtonClick(_ sender: Any) {
        if (newPasswordTextField.text != confirmPasswordTextField.text) {
            let alert = UIAlertController(title: "Error", message: "New password mismatch!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: {
                self.resetTextField()
            })
        }
        else {
            let user = Auth.auth().currentUser
            let credential: AuthCredential
            
            // Prompt the user to re-provide their sign-in credentials
            credential = EmailAuthProvider.credential(withEmail: (user?.email)!, password: oldPasswordTextField.text!)
            
            user?.reauthenticate(with: credential) { error in
                if error != nil {
                    // An error happened.
                    let alert = UIAlertController(title: "Error", message: "Old password mismatch!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: {
                        self.resetTextField()
                    })
                } else {
                    // User re-authenticated.
                    user?.updatePassword(to: self.newPasswordTextField.text!) { (error) in
                        // ...
                    }
                    NSLog("Password Changed")
                    let alert = UIAlertController(title: "Success", message: "Password Changed!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    @IBAction func cancelButtonClick(_ sender: Any) {
        let srcUserInfo = self.storyboard?.instantiateViewController(withIdentifier: "userInfo") as! AccountViewController
        self.present(srcUserInfo, animated: true)
    }

    func resetTextField() {
        confirmPasswordTextField.text?.removeAll()
        newPasswordTextField.text?.removeAll()
        oldPasswordTextField.text?.removeAll()
    }

}
