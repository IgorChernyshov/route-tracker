//
//  SignInViewController.swift
//  route-tracker
//
//  Created by Igor Chernyshov on 24.09.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignInViewController: UIViewController {
  
  @IBOutlet weak var loginText: UITextField!
  @IBOutlet weak var passwordText: UITextField!
  @IBOutlet weak var router: SignInRouter!
  @IBOutlet weak var signInButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setSignInButtonAvailability()
  }
  
  @IBAction func signInButtonWasPressed(_ sender: Any) {
    let login = loginText.text
    let password = passwordText.text
    if AuthenticationService.instance.signInUser(login: login!, password: password!) {
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
  
  func setSignInButtonAvailability() {
    Observable
      .combineLatest(
        loginText.rx.text,
        passwordText.rx.text
      )
      .map { login, password in
        return !(login ?? "").isEmpty && (password ?? "").count >= 6
      }
      .bind { [weak signInButton] inputIsFilled in
        signInButton?.isEnabled = inputIsFilled
    }
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
