//
//  GetViewControllerStoryboardID.swift
//  route-tracker
//
//  Created by Igor Chernyshov on 26/09/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit

// Protocol for objects who has a StoryboardID
protocol StoryboardIdentifiable {
  static var storyboardIdentifier: String { get }
}

// UIViewController extension that makes it compatible with our protocol
extension UIViewController: StoryboardIdentifiable { }

// Extension of our protocol for UIViewController. Sets StoryboardID = class name
extension StoryboardIdentifiable where Self: UIViewController {
  
  static var storyboardIdentifier: String {
    return String(describing: self)
  }
}

extension UIStoryboard {
  
  func instantiateViewController<T: UIViewController>(_ : T.Type) -> T {
    guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
      fatalError("Failed to find a ViewController with StoryboardID \(T.storyboardIdentifier)")
    }
    
    return viewController
  }
  
  // Same method but with different call
  func instantiateViewController<T: UIViewController>() -> T {
    guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
      fatalError("Failed to find a ViewController with StoryboardID \(T.storyboardIdentifier)")
    }
    
    return viewController
  }
}
