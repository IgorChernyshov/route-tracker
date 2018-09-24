//
//  LaunchViewController.swift
//  route-tracker
//
//  Created by Igor Chernyshov on 24.09.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if UserDefaults.standard.bool(forKey: "userIsLoggedIn") {
      performSegue(withIdentifier: "toMain", sender: self)
    } else {
      performSegue(withIdentifier: "toAuthentication", sender: self)
    }
  }
  
}
