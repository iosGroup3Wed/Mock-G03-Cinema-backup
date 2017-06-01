//
//  AccountViewController.swift
//  Mock_G03_Cinema
//
//  Created by Tran Van Tin on 6/1/17.
//  Copyright © 2017 Tran Van Tin. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Log out
    @IBAction func logOutButtonClick(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func getUserInfo() {
        let databaseRef = Database.database().reference()
        let userId = Auth.auth().currentUser?.uid
        databaseRef.child("users").child(userId!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user info and show to view
            let value = snapshot.value as? NSDictionary
            let name = value?["name"] as? String ?? ""
            let age = value?["age"] as? String ?? "18"
            let address = value?["address"] as? String ?? ""
            self.nameLabel.text = name
            self.ageLabel.text = age
            self.addressLabel.text = address
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
