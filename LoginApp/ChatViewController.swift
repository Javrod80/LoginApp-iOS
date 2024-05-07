//
//  ChatViewController.swift
//  LoginApp
//
//  Created by Mañanas on 30/4/24.
//

import UIKit
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage


class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    var chat: Chat?
    var list: [Message] = []
    let userID = Auth.auth().currentUser!.uid
    var listener: ListenerRegistration? = nil
    
    @IBOutlet var tableChatView: UITableView!
    
    @IBOutlet var chatTextView: UITextView!
    
    @IBOutlet var sendButton: UIButton!
    
    @IBOutlet var messageInputView: UIView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableChatView.dataSource = self
        tableChatView.delegate = self
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = list[indexPath.row]
        let cell :MessageViewCell = if item.senderId == userID {
            tableChatView.dequeueReusableCell(withIdentifier: "current", for: indexPath) as! MessageViewCell
        } else {
            tableChatView.dequeueReusableCell(withIdentifier: "other", for: indexPath) as! MessageViewCell
        }
        
        cell.render(message: item)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(list[indexPath.row])
        tableChatView.deselectRow(at: indexPath, animated: true)
        
    }
        
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let db = Firestore.firestore()
        listener = db.collection("messages").whereField("chatId", isEqualTo: chat?.id).order(by: "date")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                
                do {
                    self.list = []
                    for document in documents {
                        let message = try document.data(as: Message.self)
                        self.list.append(message)
                    }
                    
                    DispatchQueue.main.async {
                        self.tableChatView.reloadData()
                        if (self.list.count > 0) {
                            let lastIndexPath = IndexPath(item:self.list.count - 1, section: 0)
                            self.tableChatView.scrollToRow(at: lastIndexPath, at: .bottom, animated: false)
                        }
                    }
                } catch {
                    print("Error reading messages: \(error)")
                }
            }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener?.remove()
    }
    // formato campo texto mensaje
    func textViewDidChange(_ textView: UITextView) {
        if textView.text!.replacingOccurrences(of: " ", with: "").isEmpty {
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
        
        let size = CGSize(width: textView.frame.size.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        guard textView.contentSize.height < 100 else {
            textView.isScrollEnabled = true
            return
        }
        
        textView.isScrollEnabled = false
        textView.constraints.forEach { constraint in
            if (constraint.firstAttribute == .height) {
                constraint.constant = estimatedSize.height
            }
        }
        
        messageInputView.constraints.forEach { constraint in
            if (constraint.firstAttribute == .height) {
                constraint.constant = estimatedSize.height + 16
            }
        }
        
    }
    
    func fetchMessages() {
        let db = Firestore.firestore()
        
        var messages = [Message]()
        Task {
            do {
                let querySnapshot = try await db.collection("messages").whereField("chatId", isEqualTo: chat!.id).order(by: "date").getDocuments()
                
                for document in querySnapshot.documents {
                    let message = try document.data(as: Message.self)
                    messages.append(message)
                }
                
                list = messages
                
                DispatchQueue.main.async {
                    self.tableChatView.reloadData()
                }
            } catch {
                print("Error reading messages: \(error)")
            }
        }
    }
    
    
    
    @IBAction func sendButton(_ sender: UIButton) {
        
        let userID = Auth.auth().currentUser!.uid
        let message = Message(message: chatTextView.text!, date: Date.now.timeIntervalSince1970, senderId: userID)
        
         
         let db = Firestore.firestore()
         
         do {
         try db.collection("messages").addDocument(from: message)
             chatTextView.text = ""
         textViewDidChange(chatTextView)
         } catch let error {
         print("Error writing user to Firestore: \(error)")
         }
         }
        
        
        
        
        
        
        
    }
    
    
    
    
    
    

