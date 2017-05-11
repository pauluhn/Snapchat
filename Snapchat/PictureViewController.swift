//
//  PictureViewController.swift
//  Snapchat
//
//  Created by Roger Villarreal on 4/23/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit
import Firebase

class PictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var pictureImageView: UIImageView!
    @IBOutlet var descriptionTextField: UITextField!
    
    var imagePicker = UIImagePickerController()
    
    var uuid = NSUUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        nextButton.isEnabled = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        pictureImageView.image = image
        
        pictureImageView.backgroundColor = UIColor.clear

        nextButton.isEnabled = true
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        // check if camera is on the device
        
        imagePicker.sourceType = .photoLibrary // change to camera to enable on device
        
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
        
    }
    @IBAction func nextTapped(_ sender: Any) {
        
        nextButton.isEnabled = false
        
        // Locate folder in Firebase, move into images folder
        let imagesFolder = FIRStorage.storage().reference().child("images")
        
        // convert image selected to a jpg representation
        let imageData = UIImageJPEGRepresentation(pictureImageView.image!, 0.1)!
        
        // UUID creates a unique identifier
        // create image called "\(NSUUID().uuidString).jpg"
        imagesFolder.child("\(uuid).jpg").put(imageData, metadata: nil, completion: {(metadata, error) in
            print("we tried to upload")
            if error != nil {
                print("we have an error: \(String(describing: error))")
            } else {
                
                print(metadata!.downloadURL()!)
                
                self.performSegue(withIdentifier: "selectedUserSegue", sender: metadata?.downloadURL()!.absoluteString)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! SelectUserViewController
        nextVC.imageURL = sender as! String
        nextVC.descrip = descriptionTextField.text!
        nextVC.uuid = uuid
    }
}
