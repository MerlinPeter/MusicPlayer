//
//  LoginController.swift
//  MusicPlayer
//
//  Created by MA on 5/6/17.
//  Copyright © 2017 M A. All rights reserved.
//

import UIKit
import Firebase
class LoginController: UIViewController {
    
    @IBOutlet weak var userNameText: UITextField!
   
    @IBOutlet weak var errorLabelText: UILabel!
    @IBOutlet weak var userPasswordText: UITextField!
    
    let loginToMusicList = "LoginToMusicList"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            
            if user != nil {
                self.performSegue(withIdentifier: self.loginToMusicList, sender: nil)
            }
        }
    }
    
 
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Register",
                                      message: "Register",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        let emailField = alert.textFields![0]
                                        let passwordField = alert.textFields![1]
                                        
                                        Auth.auth().createUser(withEmail: emailField.text!,
                                                                   password: passwordField.text!) { user, error in
                                                                    if error == nil {
                                                                        Auth.auth().signIn(withEmail: emailField.text!,
                                                                                               password: passwordField.text!)
                                                                
                                                                    
                                                                    }
                                        }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)

    }
    
  
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: userNameText.text!, password: userPasswordText.text!) { (user, error) in
            self.errorLabelText.text = error?.localizedDescription
        }
        
        
        
    }
}
extension LoginController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameText {
            userNameText.becomeFirstResponder()
        }
        if textField == userPasswordText {
            textField.resignFirstResponder()
        }
        return true
    }
    
}


