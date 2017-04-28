//
//  SelectUserViewController.swift
//  Snapchat
//
//  Created by Roger Villarreal on 4/27/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit

class SelectUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var usersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usersTableView.delegate = self
        usersTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}
