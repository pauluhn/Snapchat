//
//  LogInViewController.swift
//  Snapchat
//
//  Created by Roger Villarreal on 4/20/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit
import Firebase

private let kSegueIdentifier = "signinsegue"
class LogInViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func turnUpButtonTapped(_ sender: Any) {
        signIn()
    }
    
    private func signIn() {
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            print("We tried to sign in")
            
            guard let userUnwrapped = user else {
                print("Hey we have an error: \(error?.localizedDescription ?? "nil")!")
                self.signInError(error)
                return
            }
            
            print("Signed in Successfully as: \(userUnwrapped.uid)")
            self.performSegue(withIdentifier: kSegueIdentifier, sender: nil)
        }
    }
    
    private func signInError(_ error: Error?) {
        switch errorCode(error) {
            
        case .errorCodeUserNotFound?:
            print("No user. We should try to create it")
            createUser()
            
        case .errorCodeWrongPassword?:
            print("Wrong password")
            
        default:
            print("Error not processed: \(error?.localizedDescription ?? "nil")!")
        }
    }
    
    private func createUser() {
        FIRAuth.auth()?.createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
            print("We tried to create a user")
            
            guard let userUnwrapped = user else {
                print("Hey we have an error: \(error?.localizedDescription ?? "nil")!")
                return
            }
            
            print("Created User Successfully")
            
            guard let emailUnwrapped = userUnwrapped.email else {
                print("Could not unwrap user email")
                return
            }
            
            FIRDatabase.database().reference().child("users").child(userUnwrapped.uid).child("email").setValue(emailUnwrapped)
            
            self.performSegue(withIdentifier: kSegueIdentifier, sender: nil)
        }
    }
    
    private func errorCode(_ error: Error?) -> FIRAuthErrorCode? {
        guard let errorUwrapped = error else {
            // no error
            return nil
        }
        return FIRAuthErrorCode(rawValue: (errorUwrapped as NSError).code)
    }
}

