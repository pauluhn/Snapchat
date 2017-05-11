//
//  SelectUserViewController.swift
//  Snapchat
//
//  Created by Roger Villarreal on 4/27/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit
import Firebase

class SelectUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var usersTableView: UITableView!
    
    var users : [User] = []
    
    var imageURL = ""
    var descrip = ""
    var uuid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usersTableView.delegate = self
        usersTableView.dataSource = self
        
        FIRDatabase.database().reference().child("users").observe(FIRDataEventType.childAdded, with: { (snapshot) in
            
//            print(snapshot.value!["email"]) as! String // Error
            print((snapshot.value as? NSDictionary)?["email"] as! String)
            
            let user = User()
            user.email = (snapshot.value as? NSDictionary)?["email"] as! String
            user.uid = snapshot.key
            
            self.users.append(user)
            self.usersTableView.reloadData()
            
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.email
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = users[indexPath.row]
        
        let snap = ["from": FIRAuth.auth()?.currentUser?.email, "description": descrip, "imageURL": imageURL, "uuid": uuid]
        
        FIRDatabase.database().reference().child("users").child(user.uid).child("snaps").childByAutoId().setValue(snap)
        navigationController?.popToRootViewController(animated: true)
    }
}
