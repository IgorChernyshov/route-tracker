//
//  ForgotPasswordViewController.swift
//  route-tracker
//
//  Created by Igor Chernyshov on 24.09.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

  @IBOutlet weak var loginText: UITextField!
  
  private func revealPassword(password: String) {
    let alertController = UIAlertController(title: "", message: "The password is \(password)", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
  
  @IBAction func recoverPasswordButtonWasPressed(_ sender: Any) {
    guard let login = loginText.text else { return }
    let password = AuthenticationService.instance.recoverPassword(login: login)
    if password != "" {
      revealPassword(password: password)
    }
  }
  
}
