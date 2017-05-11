//
//  ViewSnapsViewController.swift
//  Snapchat
//
//  Created by Roger Villarreal on 5/9/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class ViewSnapsViewController: UIViewController {

    var snap = Snap()
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = snap.descrip
        
        imageView.sd_setImage(with: URL(string: snap.imageURL))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).child("snaps").child(snap.key).removeValue()
        
            FIRStorage.storage().reference().child("images").child("\(snap.uuid).jpg").delete { (error) in
                print("we deleted the pic")
        }
    }

}
