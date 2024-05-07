//
//  MessageViewCell.swift
//  LoginApp
//
//  Created by Mañanas on 30/4/24.
//

import UIKit

class MessageViewCell: UITableViewCell {
    
    
    
    @IBOutlet var receiveLabel: UILabel!
    
    @IBOutlet var sendLabel: UILabel!
    
    
    func render(message: Message) {
            sendLabel.text = message.message
        }
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
