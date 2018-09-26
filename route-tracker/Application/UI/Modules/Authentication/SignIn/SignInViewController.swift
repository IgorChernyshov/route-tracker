//
//  SignInViewController.swift
//  route-tracker
//
//  Created by Igor Chernyshov on 24.09.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

  @IBOutlet weak var loginText: UITextField!
  @IBOutlet weak var passwordText: UITextField!
  
  @IBAction func signInButtonWasPressed(_ sender: Any) {
    guard
      let login = loginText.text,
      let password = passwordText.text
    else {
      return
    }
    if AuthenticationService.instance.signInUser(login: login, password: password) {
      UserDefaults.standard.set(true, forKey: "userIsLoggedIn")
      performSegue(withIdentifier: "toMain", sender: sender)
    }
  }
  
  @IBAction func registerButtonWasPressed(_ sender: Any) {
    guard
      let login = loginText.text,
      let password = passwordText.text
      else {
        return
    }
    if AuthenticationService.instance.registerUser(login: login, password: password) {
      UserDefaults.standard.set(true, forKey: "userIsLoggedIn")
      performSegue(withIdentifier: "toMain", sender: sender)
    }
  }
  
  @IBAction func forgotPasswordButtonWasPressed(_ sender: Any) {
    performSegue(withIdentifier: "toForgotPassword", sender: sender)
  }
  
}
