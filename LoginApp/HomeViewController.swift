//
//  HomeViewController.swift
//  LoginApp
//
//  Created by Mañanas on 18/4/24.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
  
    
    
    
    @IBOutlet var tableViewChat: UITableView!
    
  
    
    
    
    
    
 

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableViewChat.delegate = self
        self.tableViewChat.dataSource = self
        
        
        
        
        
        
        
        

        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : ChatViewCell = tableViewChat.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChatViewCell
       
        return cell
        
        
        
    }
    
    
    
    
    
   
    
   
    
    
    
    

 

}
