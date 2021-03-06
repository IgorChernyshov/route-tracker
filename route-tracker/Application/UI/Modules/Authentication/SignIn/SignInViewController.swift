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
  @IBOutlet weak var registerButton: UIButton!
  
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setSignInButtonAvailability()
    // Check if device is jailbroken
    if hasCydiaBundle() || writeOutOfSandbox() {
      deviceIsJailbrokenAlert()
      signInButton.isHidden = true
      registerButton.isHidden = true
    }
  }
  
  private func hasCydiaBundle() -> Bool {
    let filePath = "/Applications/Cydia.app"
    return FileManager.default.fileExists(atPath: filePath)
  }
  
  private func writeOutOfSandbox() -> Bool {
    do {
      let filePath = "/private/test.txt"
      let fileContents = "test"
      try fileContents.write(toFile: filePath, atomically: true, encoding: .utf8)
      try? FileManager.default.removeItem(atPath: filePath)
      return true
    } catch {
      return false
    }
  }
  
  private func deviceIsJailbrokenAlert() {
    let alertController = UIAlertController(title: "Jailbreak detected!", message: "The device is jailbroken - You is not allowed to login", preferredStyle: .alert)
    let closeAction = UIAlertAction(title: "Close", style: .default, handler: nil)
    alertController.addAction(closeAction)
    present(alertController, animated: true, completion: nil)
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
    // Not DRY. TODO: Rework method to bind to both buttons at once
    Observable
      .combineLatest(
        loginText.rx.text,
        passwordText.rx.text
      )
      .map { login, password in
        return !(login ?? "").isEmpty && (password ?? "").count >= 6
      }
      .bind(to: signInButton.rx.isEnabled)
      .disposed(by: disposeBag)

    Observable
      .combineLatest(
        loginText.rx.text,
        passwordText.rx.text
      )
      .map { login, password in
        return !(login ?? "").isEmpty && (password ?? "").count >= 6
      }
      .bind(to: registerButton.rx.isEnabled)
      .disposed(by: disposeBag)
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
