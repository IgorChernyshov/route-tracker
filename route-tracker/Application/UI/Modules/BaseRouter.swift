//
//  BaseRouter.swift
//  route-tracker
//
//  Created by Igor Chernyshov on 26/09/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit

class BaseRouter: NSObject {
  
  @IBOutlet weak var controller: UIViewController!
  
  func show(_ controller: UIViewController) {
    self.controller.show(controller, sender: nil)
  }
  
  func present(_ controller: UIViewController) {
    self.controller.present(controller, animated: true)
  }
  
  func setAsRoot(_ controller: UIViewController) {
    UIApplication.shared.delegate?.window??.rootViewController = controller
  }
  
}
