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
  @IBOutlet weak var router: SignInRouter!
  
  @IBAction func signInButtonWasPressed(_ sender: Any) {
    guard
      let login = loginText.text,
      let password = passwordText.text
    else {
      return
    }
    if AuthenticationService.instance.signInUser(login: login, password: password) {
      UserDefaults.standard.set(true, forKey: "userIsLoggedIn")
      router.toMain()
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
      router.toMain()
    }
  }
  
  @IBAction func forgotPasswordButtonWasPressed(_ sender: Any) {
    router.toRecover()
  }
  
}

final class SignInRouter: BaseRouter {
  func toMain() {
    let controller = UIStoryboard(name: "Main", bundle: nil)
      .instantiateViewController(MainMenuViewController.self)
    
    setAsRoot(UINavigationController(rootViewController: controller))
  }
  
  func toRecover() {
    let controller = UIStoryboard(name: "Authentication", bundle: nil)
      .instantiateViewController(RecoverPasswordViewController.self)
    
    show(controller)
  }
}
