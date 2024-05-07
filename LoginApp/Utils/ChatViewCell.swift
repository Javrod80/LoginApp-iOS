//
//  ChatViewCell.swift
//  LoginApp
//
//  Created by Mañanas on 29/4/24.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class ChatViewCell: UITableViewCell {
    
    
    @IBOutlet var imageChatUser: UIImageView!
    
    @IBOutlet var nameChatUser: UILabel!
    
    @IBOutlet var descriptionLabel: UILabel!
    
    
    
    
    func render (chat: Chat) {
        
        nameChatUser.text = chat.name
   
        
       
        
        
        
        
        
        
    }
}
