//
//  SettingsViewController.swift
//  LoginApp
//
//  Created by Mañanas on 25/4/24.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            SessionManager.shared.clearCredentials()
            self.navigationController?.navigationController?.popToRootViewController(animated: true)
        } catch {
            
        }
        
    }
    
}
