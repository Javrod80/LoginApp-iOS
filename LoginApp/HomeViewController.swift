//
//  HomeViewController.swift
//  LoginApp
//
//  Created by Mañanas on 18/4/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    
    @IBOutlet var welcomeLAbel: UILabel!
    
    var username: String? = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()

        welcomeLAbel.text = "Welcome \(username!)"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
