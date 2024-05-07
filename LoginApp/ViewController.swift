//
//  ViewController.swift
//  LoginApp
//
//  Created by Mañanas on 17/4/24.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

class ViewController: UIViewController {
    
    
    
    
    @IBOutlet var mailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var googleButton: GIDSignInButton!
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        if SessionManager.shared.isLoggedIn {
            print("Ya hay un usuario logueado")
            self.performSegue(withIdentifier: "navigateToHome", sender: self)
        } else {
            print("No hay ningun usuario logueado")
        }
        
    }
    
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navigateToTab" {
            let viewController = segue.destination as! UITabBarController
            //homeViewController.username = mailTextField.text
        }
        
    }*/
    
    
    
    
    

    
    @IBAction func registroButton(_ sender: Any) {
        
        
        let username = mailTextField.text!
        let password = passwordTextField.text!
        
        Auth.auth().createUser(withEmail: username, password: password) { authResult, error in
            if (error == nil) {
                //self.performSegue(withIdentifier: "navigateToProfile", sender: self)
                print("usuario registrado")
            }
            else {
                print (error!.localizedDescription)
            }
            authResult?.user.sendEmailVerification { error in
                        if let error = error {
                            print("Error enviando correo de verificación: \(error.localizedDescription)")
                        } else {
                            print("Correo de verificación enviado")
                        }
                    }
            
        }
        checkEmailVerificationStatus()
    }
    
  
    

    @IBAction func loginButton(_ sender: Any) {
        let username = mailTextField.text!
        let password = passwordTextField.text!
        
        Auth.auth().signIn(withEmail: username, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            if (error == nil) {
                SessionManager.shared.saveCredentials(username: username, password: password)
                self?.checkEmailVerificationStatus()
               // self?.performSegue(withIdentifier: "navigateToHome", sender: self)
            } else {
                print (error!.localizedDescription)
                
            }
            
        }
        
        
    }
    
    
    @IBAction func googleLoginButton(_ sender: Any) {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
          guard error == nil else {
              print("Error during Google sign in")
              return
            // ...
          }
            

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
              print("Failed to get user or ID token.")
                          return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                       if let error = error {
                           print("Error during Firebase authentication: \(error.localizedDescription)")
                           return
                       }
                      
                       print("User signed in with Firebase.")
                       self.performSegue(withIdentifier: "navigateToHome", sender: self)
                   }

          // ...
        }
        
        
        
        
    }
    
    func checkEmailVerificationStatus() {
        if let user = Auth.auth().currentUser {
            if user.isEmailVerified {
                self.performSegue(withIdentifier: "navigateToHome", sender: self)
                print("El correo electrónico ha sido verificado")
            } else {
                print("El correo electrónico no ha sido verificado")
            }
        }
    }
    
    
    
    
    

    
    
    
    
    
}


