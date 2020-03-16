//
//  NewContactTableViewController.swift
//  Contacts
//
//  Created by Guest on 16.03.2020.
//  Copyright © 2020 Guest. All rights reserved.
//

import UIKit
import CoreData
class NewContactTableViewController: UITableViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var familyNameField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var patronymicNameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        if familyNameField.text == "" || nameField.text == "" ||
           patronymicNameField.text == "" || phoneNumberField.text == "" {
            let alertController = UIAlertController(title: nil, message: "Please fill in all the fields", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancel)
            self.present(alertController, animated: true, completion: nil)
        } else {
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let contact = Contact(context: context)
                contact.name = nameField.text
                contact.familyName = familyNameField.text
                contact.patronymicName = patronymicNameField.text
                contact.phoneNumber = phoneNumberField.text
                
                if let image = imageView.image {
                    contact.image = image.pngData()
                }
                
                do {
                  try context.save()
                    
                } catch let error as NSError {
                    let alertController = UIAlertController(title: "Error", message: "\(error), \(error.userInfo)", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(cancel)
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
            
            performSegue(withIdentifier: "unwindFromNewContact", sender: self)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorColor = UIColor.clear
        nameField.delegate = self
        familyNameField.delegate = self
        patronymicNameField.delegate = self
        phoneNumberField.delegate = self
    }

    func chooseImagePickerAction(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let alertController = UIAlertController(title: "Add photo", message: nil, preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Take a new shot", style: .default) { (action) in
                self.chooseImagePickerAction(source: .camera)
            }
            let library = UIAlertAction(title: "Choose from library", style: .default) { (action) in
                self.chooseImagePickerAction(source: .photoLibrary)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(camera)
            alertController.addAction(library)
            alertController.addAction(cancel)
            self.present(alertController, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
   
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        super.view.endEditing(true)
        
    }
    
}

extension NewContactTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
}

extension NewContactTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        for textField in self.view.subviews where textField is UITextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
}
