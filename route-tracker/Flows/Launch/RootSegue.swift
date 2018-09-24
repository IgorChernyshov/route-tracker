//
//  RootSegue.swift
//  route-tracker
//
//  Created by Igor Chernyshov on 24.09.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit

class RootSegue: UIStoryboardSegue {
  
  override func perform() {
    UIApplication.shared.delegate?.window??.rootViewController = destination
  }
  
}