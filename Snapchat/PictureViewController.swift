//
//  PictureViewController.swift
//  Snapchat
//
//  Created by Roger Villarreal on 4/23/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit
import Firebase

private let kSegueIdentifier = "selectedUserSegue"
class PictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var pictureImageView: UIImageView!
    @IBOutlet var descriptionTextField: UITextField!
    
    private var imagePicker = UIImagePickerController()
    
    private var uuid = UUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        nextButton.isEnabled = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        pictureImageView.image = image
        
        pictureImageView.backgroundColor = .clear

        nextButton.isEnabled = true
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        // TODO: check if camera is on the device
        
        imagePicker.sourceType = .photoLibrary // TODO: change to camera to enable on device
        
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
        
    }
    @IBAction func nextTapped(_ sender: Any) {
        
        nextButton.isEnabled = false
        
        // Locate folder in Firebase, move into images folder
        let imagesFolder = FIRStorage.storage().reference().child("images")
        
        // convert image selected to a jpg representation
        guard let imageData = UIImageJPEGRepresentation(pictureImageView.image!, 0.1) else {
            print("Could not get image data")
            return
        }
        
        // UUID creates a unique identifier
        // create image called "\(UUID().uuidString).jpg"
        imagesFolder.child("\(uuid).jpg").put(imageData, metadata: nil) { (metadata, error) in
            print("we tried to upload")
            
            guard let metadataUnwrapped = metadata else {
                print("we have an error: \(String(describing: error))")
                return
            }
            guard let url = metadataUnwrapped.downloadURL() else {
                print("we have a problem with the url: \(String(describing: metadataUnwrapped.downloadURL()))")
                return
            }
            print(url)
            
            self.performSegue(withIdentifier: kSegueIdentifier, sender: url.absoluteString)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kSegueIdentifier {
            guard let nextVC = segue.destination as? SelectUserViewController,
                let url = sender as? String else {
                    print("Could not unwrap VC(\(segue.destination)) as SelectUserViewController or sender(\(sender ?? "nil") as String)")
                    return
            }
            nextVC.imageURL = url
            nextVC.descrip = descriptionTextField.text!
            nextVC.uuid = uuid
        }
    }
}
