//
//  MainMenuViewController.swift
//  route-tracker
//
//  Created by Igor Chernyshov on 24.09.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
  
  @IBOutlet var router: MainMenuRouter!
  
  @IBAction func showMapButtonWasPressed(_ sender: Any) {
    router.toMap()
  }
  
  @IBAction func takeSelfieButtonWasPressed(_ sender: Any) {
    guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
    let imagePickerController = UIImagePickerController()
    imagePickerController.sourceType = .camera
    imagePickerController.allowsEditing = true
    imagePickerController.delegate = self
    
    router.toSelfie()
  }
  
  @IBAction func logoutButtonWasPressed(_ sender: Any) {
    UserDefaults.standard.set(false, forKey: "userIsLoggedIn")
    router.toSignIn()
  }
  
}

extension MainMenuViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let image = extractImage(from: info)
    print(image)
    
    picker.dismiss(animated: true)
  }
  
  private func extractImage(from info: [UIImagePickerController.InfoKey : Any]) -> UIImage? {
    if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
      return image
    } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      return image
    } else {
      return nil
    }
  }
}

final class MainMenuRouter: BaseRouter {
  
  func toMap() {
    let controller = UIStoryboard(name: "Main", bundle: nil)
      .instantiateViewController(MapViewController.self)
    
    show(controller)
  }
  
  func toSelfie() {
    let controller = UIStoryboard(name: "Main", bundle: nil)
      .instantiateViewController(SelfieViewController.self)
    
    present(controller)
  }
  
  func toSignIn() {
    let controller = UIStoryboard(name: "Authentication", bundle: nil)
      .instantiateViewController(SignInViewController.self)
    
    setAsRoot(UINavigationController(rootViewController: controller))
  }
}
