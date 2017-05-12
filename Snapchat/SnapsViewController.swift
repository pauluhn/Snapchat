//
//  SnapsViewController.swift
//  Snapchat
//
//  Created by Roger Villarreal on 4/22/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit
import Firebase

private let kCellIdentifier = "SnapsCellIdentifier"
private let kSegueIdentifier = "viewSnapSegue"

class SnapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    private var snaps: [Snap] = []
    private var ref = FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).child("snaps")
    
    @IBAction func logoutTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        ref.observe(FIRDataEventType.childAdded, with: { (snapshot) in
            
            print(snapshot)
            
            let snap = Snap()
            snap.imageURL = (snapshot.value as? NSDictionary)?["imageURL"] as! String
            snap.descrip = (snapshot.value as? NSDictionary)?["description"] as! String
            snap.from = (snapshot.value as? NSDictionary)?["from"] as! String
            snap.key = snapshot.key
            snap.uuid = (snapshot.value as? NSDictionary)?["uuid"] as! String
            
            self.snaps.append(snap)
            self.tableView.reloadData()
        })
        
        ref.observe(FIRDataEventType.childRemoved, with: { (snapshot) in
            
            print(snapshot)
            
            var index = 0
            for snap in self.snaps {
                if snap.key == snapshot.key {
                    self.snaps.remove(at: index)
                }
                index += 1
            }
            self.tableView.reloadData()
            
        })
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath)
        
        if snaps.isEmpty {
            cell.textLabel?.text = "You have no snaps 😢"
        } else {

            let snap = snaps[indexPath.row]

            cell.textLabel?.text = snap.from
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if snaps.isEmpty {
            return 1
        } else {
            return snaps.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard !snaps.isEmpty else { return } // fix bug where you tap the "You have no snaps" row
        
        let snap = snaps[indexPath.row]
        
        performSegue(withIdentifier: kSegueIdentifier, sender: snap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kSegueIdentifier {
            guard let nextVC = segue.destination as? ViewSnapsViewController,
                let snap = sender as? Snap else {
                    print("Could not unwrap VC(\(segue.destination)) as ViewSnapsViewController or sender(\(sender ?? "nil") as Snap)")
                    return
            }
            nextVC.snap = snap
        }
    }
    
}
