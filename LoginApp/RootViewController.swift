//
//  RootViewController.swift
//  LoginApp
//
//  Created by Mañanas on 25/4/24.
//

import UIKit

class RootViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    //para quitar visualización de navigationController al entrar y volver a visualizar al salir
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    

    

}
