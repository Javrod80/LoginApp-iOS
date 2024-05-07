//
//  ProfileViewController.swift
//  LoginApp
//
//  Created by Mañanas on 23/4/24.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage




class ProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    
    @IBOutlet var firstNameTextFiled: UITextField!
    
    @IBOutlet var lastNameTextField: UITextField!
    
    @IBOutlet var ageTextField: UITextField!
    
    @IBOutlet var maleFemaleTextField: UITextField!
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    @IBOutlet var dateBirthday: UIDatePicker!
    
    @IBOutlet var profileImage: UIImageView!
    
    
    
    var male : String = "Male"
    var female: String = "Female"
    var otros: String = "Otros"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userID = Auth.auth().currentUser!.uid
        let db = Firestore.firestore()
        let docRef = db.collection("user").document(userID)
        
        
        
        
        
        Task {
            do{
                let document = try await docRef.getDocument()
                if document.exists {
                    if let dataDescription = document.data() {
                        print ("Document data: \(dataDescription)")
                        firstNameTextFiled.text = dataDescription ["firstName"] as? String
                        lastNameTextField.text = dataDescription ["lastName"] as? String
                        ageTextField.text = dataDescription ["age"] as? String
                        maleFemaleTextField.text = dataDescription ["male/female"] as? String
                        dateBirthday.date = Date(timeIntervalSince1970: dataDescription ["fecha de nacimiento"] as? Double ?? 0)
                        let imageUrl = dataDescription ["image"] as? String
                        if (imageUrl != nil && !imageUrl!.isEmpty) {
                            profileImage.loadImage(fromURL: imageUrl!)
                        }
                    }
                }
                else {
                    print("Document does not exist")
                }
            }
            catch {
                print("Error getting document: \(error)")
            }
        }
    }
    @IBAction func saveButton(_ sender: UIButton) {
        let userID = Auth.auth().currentUser!.uid
        let db = Firestore.firestore()
        
        
        
        
        Task {
            do{
                try await db.collection("user").document(userID).setData(["firstName": firstNameTextFiled.text!, "lastName": lastNameTextField.text!, "age": ageTextField.text!,"male/female": maleFemaleTextField.text!,"fecha de nacimiento": dateBirthday.date.timeIntervalSince1970])
                
                print ("Document added with ID : \(userID)")
            } catch {
                print ("Error adding document: \(error)")
            }
        }
        guard let imageData = profileImage.image?.jpegData(compressionQuality: 0.75) else { return }
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("yourImageName.jpg")
        let uploadTask = imageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
            } else {
                print("Image uploaded successfully")
            }
            //obtener url
            imageRef.downloadURL { (url, error) in
                if let error = error {
                    print("Error al obtener la URL de descarga: \(error)")
                    return
                }
                
                guard let downloadURL = url else { return }
                
                // Guardar la URL de descarga en Firebase Database
                let databaseRef = db.collection("user").document(userID)
                databaseRef.setData(["image": downloadURL.absoluteString], merge: true) { (error) in
                    if let error = error {
                        print("Error al guardar la URL en Firebase Database: \(error)")
                        return
                    }
                    
                    print("Imagen de perfil subida y URL guardada correctamente.")
                }
            }
        }
        
    }
    
    
    
    @IBAction func maleFemaleButton(_ sender: UISegmentedControl) {
        
        let selectedSegment = sender.selectedSegmentIndex
        
        print("Selected segment: \(selectedSegment)")
        if selectedSegment == 0 {
            maleFemaleTextField.text = male
        }
        if selectedSegment == 1 {
            maleFemaleTextField.text = female
        }
        if selectedSegment == 2 {
            maleFemaleTextField.text = otros
        }
        
    }
    
    
    
    @IBAction func imagePicker(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 200) {
            try? jpegData.write(to: imagePath)
        }
        profileImage.image = image
        
        
        dismiss(animated: true)
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    //cargar imagen
    
    func loadProfileImage(userID: String, completion: @escaping (UIImage?) -> Void) {
        let db = Firestore.firestore()
        
        let databaseRef = db.collection("user").document(userID)
        databaseRef.addSnapshotListener { DocumentSnapshot, error  in
            guard let value = DocumentSnapshot as? [String: AnyObject],
                  let imageURLString = value["image"] as? String,
                  let imageURL = URL(string: imageURLString) else {
                completion(nil)
                return
            }
            
            URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                if let error = error {
                    print("Error al cargar la imagen: \(error)")
                    completion(nil)
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    completion(nil)
                    return
                }
                
                completion(image)
            }.resume()
            
        }
        
        
        
        
        
        
        
        
        
    }
    
    
    
}
