//
//  ViewController.swift
//  LoginApp
//
//  Created by Mañanas on 17/4/24.
//

import UIKit
import FirebaseAuth
class ViewController: UIViewController {
    
    
    
    
    @IBOutlet var mailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navigateToHome" {
            let homeViewController = segue.destination as! HomeViewController
            homeViewController.username = mailTextField.text
        }
        
    }
    
    
    
    
    

    
    @IBAction func registroButton(_ sender: Any) {
        let username = mailTextField.text!
        let password = passwordTextField.text!
        
        Auth.auth().createUser(withEmail: username, password: password) { authResult, error in
            if (error == nil) {
                self.performSegue(withIdentifier: "navigateToHome", sender: self)
            } 
            else {
                print (error!.localizedDescription)
            }
        }
    }
    
  
    

    @IBAction func loginButton(_ sender: Any) {
        let username = mailTextField.text!
        let password = passwordTextField.text!
        
        Auth.auth().signIn(withEmail: username, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            if (error == nil) {
                self?.performSegue(withIdentifier: "navigateToHome", sender: self)
            } else {
                print (error!.localizedDescription)
                
            }
        }
    }
    
}


