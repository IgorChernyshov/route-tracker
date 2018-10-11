//
//  SelfieMarker.swift
//  route-tracker
//
//  Created by Igor Chernyshov on 11/10/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import Foundation
import GoogleMaps

class SelfieMarker: GMSMarker {
  
  override init() {
    super.init()
    // Set selfie image to marker instead of simple pin if selfie is available
    guard let selfieImage = getSavedSelfieImage() else { return }
    self.icon = selfieImage
    self.groundAnchor = CGPoint(x: 0.5, y: 1)
  }
  
  private func resizeSelfie(selfie: UIImage) -> UIImage {
    var aspectRatio: CGFloat
    var newSize: CGSize
    
    let selfieHeight = selfie.size.height
    let selfieWidth = selfie.size.width
    
    if selfieHeight > selfieWidth {
      aspectRatio = selfieWidth / selfieHeight
      newSize = CGSize(width: 100 * aspectRatio, height: 100)
    } else {
      aspectRatio = selfieHeight / selfieWidth
      newSize = CGSize(width: 100, height: 100 * aspectRatio)
    }
    
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
    selfie.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
    let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return newImage
  }
  
  private func getSavedSelfieImage() -> UIImage? {
    guard let documentsDirectory = FileManager.default.urls(
      for: .documentDirectory,
      in: .userDomainMask
      ).first else { return nil }
    let selfieFilePath = documentsDirectory.appendingPathComponent("selfie.png").path
    guard let selfie = UIImage(contentsOfFile: selfieFilePath) else { return nil }
    let resizedSelfie = resizeSelfie(selfie: selfie)
    return resizedSelfie
  }
}
