//
//  MainMenuViewController.swift
//  route-tracker
//
//  Created by Igor Chernyshov on 24.09.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

  @IBAction func showMapButtonWasPressed(_ sender: Any) {
    performSegue(withIdentifier: "toMap", sender: sender)
  }
  
  @IBAction func logoutButtonWasPressed(_ sender: Any) {
    UserDefaults.standard.set(false, forKey: "userIsLoggedIn")
    performSegue(withIdentifier: "toLaunch", sender: sender)
  }
  
}

final class MainMenuRouter: BaseRouter {
  func toMap() {
    let controller = UIStoryboard(name: "Main", bundle: nil)
      .instantiateViewController(MapViewController.self)
    
    show(controller)
  }
  
  func toSignIn() {
    let controller = UIStoryboard(name: "Authentication", bundle: nil)
      .instantiateViewController(SignInViewController.self)
    
    setAsRoot(UINavigationController(rootViewController: controller))
  }
}
