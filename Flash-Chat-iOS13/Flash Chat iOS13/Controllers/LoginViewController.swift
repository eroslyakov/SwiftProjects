//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    var errorLabel: ErrorLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel = ErrorLabel(view: self.view)
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        emailTextfield.endEditing(true)
        passwordTextfield.endEditing(true)
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    self.errorLabel.showErrorMessage(message: e.localizedDescription)
                    return
                }
                self.performSegue(withIdentifier: K.loginSegue, sender: self)
            }
        }
    }
    
    @IBAction func changeEmail(_ sender: UITextField) {
        if errorLabel.doesLabelContainMessage {
            errorLabel.hideErrorMessage()
        }
    }
    
    @IBAction func changePassword(_ sender: UITextField) {
        if errorLabel.doesLabelContainMessage {
            errorLabel.hideErrorMessage()
        }
    }
    
}
